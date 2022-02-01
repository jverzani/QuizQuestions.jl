# A simple self-grading quiz

```@setup quiz
using QuizQuestions
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
