# A simple self-grading quiz

```@setup quiz
using QuizQuestions
using Plots
```

Match `abc`

```@example quiz
re = Regex("abc")  # hide
stringq(re)  # hide
```

What is ``\sin(\frac{\pi}{2})``?

```@example quiz
a = 1  # hide
numericq(a)  # hide
```

What is ``100`` centimeters in meters?

```@example quiz
a = 1  # hide
numericq(a, units="meter(s)", hint="It is 1")  # hide
```


What is ``\sqrt{2}``?

```@example quiz
a = sqrt(2)  # hide
Δ = 1e-2  # hide
numericq(a, Δ, hint="use 3 digits")  # hide
```


What is "one"?

```@example quiz
choices = ("``1``", "``2``", "``3``")  # hide
answer = 1  # hide
radioq(choices, answer, hint="select the number matching the word", keep_order=true)  # hide
```

Which is the letter?

```@example quiz
choices = ["beta", raw"``\beta``", "`beta`"]  # hide
answer = 2  # hide
radioq(choices, answer; hint="Which is the Greek symbol?")  # hide
```



```@example quiz
choices = [raw"``\sin(\pi/6)``", raw"``\cos(\pi/4)``", raw"\tan(\pi/3)``"]
matches = [raw"``1/2``", raw"``\sqrt{2}/2``", raw"``\sqrt{3}/2``", raw"``\sqrt{3}``"]
answer = (1, 2, 4)
matchq(choices, matches, answer, label="Match the expression with the value")
```

```@example
using Plots
p1 = plot(x -> x^2, axis=nothing, legend=false)
p2 = plot(x -> x^3, axis=nothing, legend=false)
p3 = plot(x -> -x^2, axis=nothing, legend=false)
p4 = plot(x -> -x^3, axis=nothing, legend=false)
l = @layout [a b; c d]
p = plot(p1, p2, p3, p4, layout=l)
imgfile = tempname() * ".png"
savefig(p, imgfile)
hotspotq(imgfile, (0,0), (1/2, 1/2), label="What best matches the graph of ``f(x) = -x^4``?")
```
