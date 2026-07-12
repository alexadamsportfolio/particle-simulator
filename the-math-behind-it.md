This is a rather basic particles-in-a-box simulation I made for the purpose of learning Julia. 
Keep in mind that results are highly dependent on initial conditions; for instance, two particles spawning close to each other may cause a chain reaction of rapidly increasing temperature.
Below are charts of varying interaction force functions and their associated particle velocity distributions, as compared to the analogous Maxwell-Boltzmann distribution.

## Inverse Square Law

The simplest interaction function: a repelling force inversely proportional to the square of distance (e.g. Coulomb's law).
In the code, it takes the form of $$|\vec{F}| \propto \frac{1}{r^2}$$. 
Below is the resulting distribution:

<img width="1919" height="1018" alt="InverseSquare" src="https://github.com/user-attachments/assets/3e968bd5-c9d9-4529-af0f-94386893d75e" />

As we can see, after thousands of iterations the distribution takes the shape of a Maxwell-Boltzmann distribution, albeit with more extreme deviation. 
This makes sense, since the original Maxwell-Boltzmann distribution only assumes simple elastic collisions, rather than continuous force fields.

## Lennard-Jones Force

The Lennard-Jones potential accounts for short-range repulsion and long-term attraction, making it one of the most accurate functions in molecular physics.
Its derived force takes the form of $$|\vec{F}| \propto 2 * \frac{20^{12}}{r^{13}} - \frac{20^6}{r^7}$$
Below is the resulting distribution:

<img width="1919" height="1013" alt="LennardJones" src="https://github.com/user-attachments/assets/61a44de4-e1d7-43c3-9850-0aa9c0570ccf" />

Not only is a more extreme deviation present, but this distribution is notably centered more towards higher velocities than in a traditional Maxwell-Boltzmann distribution. 
