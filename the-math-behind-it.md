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

Not only is a more extreme deviation present, but this distribution is notably centered more towards higher velocities than in a traditional Maxwell-Boltzmann distribution. This result was more surprising, as the Lennard-Jones potential is supposed to be more realistic than the aforementioned inverse square law.

## Gaussian 

The Gaussian function is ubiquitous in statistics, so for the sake of mathematical curiosity I decided to define a force function in the form of $$|\vec{F}| \propto e^{-x^2}$$. Below is the resulting distribution:

<img width="1919" height="1019" alt="Gaussian" src="https://github.com/user-attachments/assets/63d83e05-095f-4c4c-a6b5-86e9e788b03f" />

Once again, we obtain a more right-centered distribution with elevated deviation. At this point, it is tempting to believe that this distribution - and potentially the Lennard-Jones one - are not Maxwell-Boltzmann, but instead normally distributed. Investigating this will be an interesting exercise when I develop more experience in statistical mechanics.

## Sinc Function

As a massive fan of harmonic analysis, I've always held a particular admiration for the function $$sinc(x) = \frac{sin(x)}{x}$$. Though a beautiful function with endless applications in signal processing, there is little physical sense to a force function that flip-flops back and forth between attraction and repulsion endlessly, and so it should be ridiculous that the resulting velocity distribution should anywhere near resemble Maxwell-Boltzmann. Right?

<img width="1919" height="1015" alt="Sinc" src="https://github.com/user-attachments/assets/f60250ac-39cc-4d72-a034-d5da3fb8c852" />

Using the sinc function for force matches the Maxwell-Boltzmann distribution in a way that none of the other functions come close to. I don't know why; maybe it's because its harmonic properties provide it with a much more mathematically pure form of diffusion, or maybe all those properties simply become irrelevant at the macrostate level. Either way, harmonics are beautiful, macrostates are beautiful, and my academic journey will be built on both.
