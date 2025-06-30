# Copyright (c) 2017-2025 Intel Corporation.
#
# SPDX-License-Identifier: MIT

import collections
import gc
import importlib
import numpy as np
import os


Timer = collections.namedtuple('Timer',
                               ('name', 'module', 'now', 'time_delta'))


def get_timer(time_modules=('itimer', 'timeit', 'time')):
    '''
    Get some timer which we can use for benchmarking.

    Parameters
    ----------
    time_modules : iterable, default ('itimer', 'timeit', 'time')
        Timer modules to try, in order of preference

    Returns
    -------
    Timer
        Timer object (namedtuple) with attributes:
        name : str
            name of timer
        module : Python module
            actual Python module containing timer
        now : function
            function to get some description of the current time
        time_delta : function(t0, t1)
            function to find the delta in seconds between two executions of
            now()
    '''
    for mod_name in time_modules:
        try:
            timer_module = importlib.import_module(mod_name)
        except ImportError:
            pass
        else:
            timer_name = mod_name
            break

    now = {
        'itimer': lambda: timer_module.itime(),
        'timeit': lambda: timer_module.default_timer(),
        'time': lambda: timer_module.time()
    }[timer_name]

    time_delta = {
        'itimer': lambda t0, t1: timer_module.itime_delta_in_seconds(t0, t1),
        'timeit': lambda t0, t1: t1 - t0,
        'time': lambda t0, t1: t1 - t0
    }[timer_name]

    return Timer(timer_name, timer_module, now, time_delta)


def set_threads(num_threads=None, verbose=False, no_guessing=False):
    '''
    Get and set the number of threads used by FFT libraries.

    Parameters
    ----------
    num_threads : int, default None
        Number of threads requested. If None, do not set threads.
    verbose : bool, default False
        If True, output debug messages to STDOUT.
    no_guessing : bool, default false
        If False and MKL is not found at all, return a guess of 1 thread
        since numpy.fft and scipy.fftpack are single-threaded without MKL.
        If True, return len(os.sched_getaffinity(0)) or os.cpu_count().

    Returns
    -------
    int or None
        The number of threads successfully set, or None on failure.
    '''

    try:
        import mkl
    except ImportError:
        if hasattr(np, '__mkl_version__') or no_guessing:
            # MKL present but no mkl-service, so guess number of CPUs
            if verbose:
                print(f'TAG: WARNING: mkl-service module was not '
                      f'found. Number of threads is likely inaccurate!')
            if hasattr(os, 'sched_getaffinity'):
                return len(os.sched_getaffinity(0)), 'os.sched_getaffinity'
            else:
                return os.cpu_count(), 'os.cpu_count'
        else:
            # no MKL, so assume not threaded
            return 1, 'guessing'
    else:
        if num_threads:
            mkl.set_num_threads(num_threads)
        return mkl.get_max_threads(), 'mkl.get_max_threads'

    return None, None


def get_random_state_and_name(seed=7777):
    try:
        import numpy.random_intel as rnd
        rs = rnd.RandomState(seed, brng='MT19937')
        return rs, 'numpy.random_intel'
    except ImportError:
        import numpy.random as rnd
        rs = rnd.RandomState(seed)
        return rs, 'numpy.random'


def get_random_state(seed=7777):
    return get_random_state_and_name(seed)[0]


conda_env = os.environ.get('CONDA_DEFAULT_ENV',
                           'None, -- conda not activated --')
print("TAG: CONDA_DEFAULT_ENV = " + conda_env)
try:
    print('TAG: numpy.__mkl_version__ = %s' % np.__mkl_version__)
except AttributeError:
    print('TAG: numpy.__mkl_version__ = None')


def time_func(func, x, kwargs, timer=None, batch_size=16, repetitions=24,
              refresh_buffer=True, verbose=False):
    """
    Time evaluation of func(x, **kwargs) and report the total time of
    `batch_size` evaluations, and produces `repetitions` measurements.

    If `refresh_buffer` is set to True, the input array is copied into the
    buffer before every call to func. This is useful for timing of functions
    working in-place.
    """
    if not isinstance(x, np.ndarray):
        raise ValueError('The argument x must be a Numpy array')
    if not isinstance(kwargs, dict):
        raise ValueError('The keywords must be a dictionary, corresponding to '
                         'keyword argument to func')
    if not timer:
        timer = get_timer()
        if verbose:
            print(f'TAG: timer = {timer.name}')
    #
    times_list = np.empty((repetitions,), dtype=np.float64)

    # allocate the buffer
    buf = np.empty_like(x)
    np.copyto(buf, x)

    # warm-up
    gc.collect()
    gc.disable()
    t0 = timer.now()
    res = func(buf, **kwargs)
    t1 = timer.now()
    time_tot = timer.time_delta(t0, t1)

    # Determine optimal batch_size
    actual_batch_size = batch_size
    if time_tot * batch_size > 5:
        actual_batch_size = 1 + int(5/time_tot)

    if verbose:
        print(f'TAG: batch_size={batch_size}, repetitions={repetitions}, '
              f'refresh_buffer={refresh_buffer}, '
              f'actual_batch_size={actual_batch_size}')

    # start measurements
    for i in range(repetitions):
        time_tot = 0
        if refresh_buffer:
            for _ in range(actual_batch_size):
                np.copyto(buf, x)
                t0 = timer.now()
                res = func(buf, **kwargs)
                t1 = timer.now()
                time_tot += timer.time_delta(t0, t1)
        else:
            t0 = timer.now()
            for _ in range(actual_batch_size):
                res = func(buf, **kwargs)
            t1 = timer.now()
            time_tot += timer.time_delta(t0, t1)
        #
        times_list[i] = time_tot / actual_batch_size
    gc.enable()
    return times_list


def print_summary(data, header=''):
    a = np.array(data)
    print("TAG: " + header)
    print('{min:0.3f}, {med:0.3f}, {max:0.3f}'.format(
        min=np.min(a), med=np.median(a), max=np.max(a)
    ))
    print("", flush=True)


def arg_signature(ar):
    if ar.flags['C_CONTIGUOUS']:
        qual = 'C-contig.'
    elif ar.flags['F_CONTIGUOUS']:
        qual = 'F-contig.'
    else:
        if np.all(np.array(ar.strides) % ar.itemsize == 0):
            # strides multiple of element size
            qual = f'strides: {tuple(x // ar.itemsize for x in ar.strides)} ' \
                   f'elems'
        else:
            # strides not divisible by element size
            qual = f'strides: {ar.strides} bytes'
    return f' arg: shape: {ar.shape}, dtype: {ar.dtype}, {qual}'


def measure_and_print(fn, ar, kw, **opts):
    perf_times = time_func(fn, ar, kw, **opts)
    print_summary(perf_times,
                  header=f'{fn.__name__}({arg_signature(ar)}, {kw})')
    return perf_times
