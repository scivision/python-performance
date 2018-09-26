
def pisum(N: int) -> float:
    """
    Machin formula for Pi http://mathworld.wolfram.com/PiFormulas.html
    """

    s: float = 0.
    k: int
    for k in range(1, N+1):
        s += (-1.)**(k+1) / (2*k-1)

    return 4.*s
