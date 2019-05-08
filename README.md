# VisualSieve
This project is a simple visual quadratic sieve for catching primes. It's made with [Processing](https://processing.org/), a language and IDE built on Java designed to make it easier to code and draw with code.

## Purpose
This project gives a visual way to generate primes by sieving out all composite numbers up to a given number (represented in this visualization by the highest integer on the y-axis times two). This leaves us with primes. Composites are blue, and primes are green.

## How it looks
![Preview](https://blakeearth.github.io/VisualSieve/preview.gif)

## How it works
1. We start by drawing the parabola ![x=y^2](https://blakeearth.github.io/VisualSieve/math/parabola.PNG). 
2. Then, we connect each integer point on one branch (above or below the x-axis, starting with ![+2 or -2](https://blakeearth.github.io/VisualSieve/math/two.PNG), since we don't care about multiples of one for finding composites) of the parabola to each integer point on the opposite branch (and vice versa). 
> Notice that just as the line between the points on the parabola where ![y=i](https://blakeearth.github.io/VisualSieve/math/y-equals-i.PNG) and ![y=-i](https://blakeearth.github.io/VisualSieve/math/y-equals-minus-i.PNG) intersects the ![x](https://blakeearth.github.io/VisualSieve/math/x.PNG)-axis at ![i^2](https://blakeearth.github.io/VisualSieve/math/i-squared.PNG), the line between the points on the parabola where ![y=i](https://blakeearth.github.io/VisualSieve/math/y-equals-i.PNG) and ![y=-i](https://blakeearth.github.io/VisualSieve/math/y-equals-minus-j.PNG) intersects the x-axis at ![i X j](https://blakeearth.github.io/VisualSieve/math/i-times-j.PNG) (find a nice visual explanation of why this is [here](https://plus.maths.org/content/catching-primes)).
3. The parabola ![x=y^2](https://blakeearth.github.io/VisualSieve/math/parabola.PNG) has x-values for every integer y, so as we draw this parabola and connect the points on it as described, we draw lines that intersect the x-axis at every composite number. 
4. When we find a new intersection like this, we mark the point on the x-axis blue and stop checking it since we know it's composite. 
5. When our current maximum y-value exceeds anything that could be a factor of a given x (defined for this visualization as anything greater than ![x/2](https://blakeearth.github.io/VisualSieve/math/x-divided-by-two.PNG)), we mark it green and can be certain that it's prime.

### Sources and further reading
This visual sieve was invented by Russian mathemeticians Yuri Matiyasevich and Boris Stechkin.
1. [A visual explanation of why we cross the points we do (and more about this sieve)](https://plus.maths.org/content/catching-primes)
2. [A brief explanation of quadratic sieves, including the visual sieve](http://mathworld.wolfram.com/QuadraticSieve.html)

## Usage
### Jarfile
To run this visualization, download and execute the jarfile associated with the most recent release (see the [releases page](https://github.com/blakeearth/VisualSieve/releases/)). Read the notes for the version; you might need to install a JDK.

### Processing
If you would rather run the visualization in Processing, download [Processing](https://processing.org/) and the source code associated with the most recent release (see the [releases page](https://github.com/blakeearth/VisualSieve/releases/)). Extract the source code and open a `.pde` file in the resulting folder to open the Sketch. Then, press the play icon to run.
