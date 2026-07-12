This is a rather basic particles-in-a-box simulation I made for the purpose of learning Julia. 
Keep in mind that results are highly dependent on initial conditions; for instance, two particles spawning close to each other may cause a chain reaction of rapidly increasing temperature.
Below are charts of varying interaction force functions and their associated particle velocity distributions, as compared to the analogous Maxwell-Boltzmann distribution.

## Inverse Square Law

The simplest interaction function: a repelling force inversely proportional to the square of distance (e.g. Coulomb's law).
In the code, it is defined as $$|\vec{F}| = \frac{1}{r^2}$$. Below is the resulting distribution:

<img width="1919" height="1018" alt="InverseSquare" src="https://github.com/user-attachments/assets/3e968bd5-c9d9-4529-af0f-94386893d75e" />

As we can see, after thousands of iterations the distribution takes the shape of a Maxwell-Boltzmann distribution, albeit with more extreme variance. 
This is likely because the original Maxwell-Boltzmann distribution assumes simple elastic collisions, rather than continuous force fields.
