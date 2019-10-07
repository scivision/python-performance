package main

import ("math"
        "testing")

func BenchmarkPower(b *testing.B) {
    for i := 0; i < b.N; i++ {
        math.Pow(10, -3)
    }
}