# Necessary imports
using Printf
using Statistics
using LinearAlgebra
using GLMakie
GLMakie.activate!() 


# Define particle properties
mutable struct Particle
    pos::Vector{Float64}
    vel::Vector{Float64}
    force::Vector{Float64}
    rad::Float64
    mass::Float64
end


# Compute the force
function force(a, b)
    r = b.pos .- a.pos
    dist = norm(r) + 1e-9
    # mag = (12 * 20^12 / dist^13 - 6 * 20^6 / dist^7)  # Lennard-Jones force
    # mag = (1 / dist^2)    # Inverse square law
    # mag = exp(-(dist/20)^2) # Gaussian
    mag = sin(dist)/dist  # Sinc function
    return mag .* (r ./ dist)
end


# Compute the kientic energy of the system
function kinetic_energy(particles)
    return sum(0.5 * p.mass * dot(p.vel, p.vel) for p in particles)
end


# Maxwell-Boltzmann distribution for reference
function maxwell_boltzmann(v,T)
    return sqrt(2/pi) .* (v.^2 ./ T^(3/2)) .* exp.(-v.^2 ./ (2T))
end


# Declare variables
dt = .001
p_array = Vector{Particle}()


# Initialize particles
for i in 1:1000
    push!(p_array, Particle(
        [4000*(rand()-.5),
         4000*(rand()-.5),
         4000*(rand()-.5)],
        [.002*(rand()-.5),
         .002*(rand()-.5),
         .002*(rand()-.5)],
        [0.0, 0.0, 0.0],
        0.5,
        1.0))
end


# Compute forces between particles
function compute_forces!(particles)

    # Clear old forces
    for p in particles
        p.force .= 0.0
    end

    # Add pairwise forces
    for i in 1:length(particles)-1
        for j in i+1:length(particles)

            f = force(particles[i], particles[j])

            particles[i].force .-= f
            particles[j].force .+= f
        end
    end
end


# Simulate particle interactions
function simulate()

    xmin, xmax = -2000.0, 2000.0
    ymin, ymax = -2000.0, 2000.0
    zmin, zmax = -2000.0, 2000.0
    iter = 1

    # Configure the plots
    positions = Observable([
    Point3f(p.pos...)
    for p in p_array
    ])
    hist_values = Observable(Float64[])
    curve_x = Observable(Float64[])
    curve_y = Observable(Float64[])
    fig = Figure(size=(1200,600))

    # 3D particle plot
    ax_particles = Axis3(
        fig[1,1],
        title="Particle Positions",
        xlabel="x",
        ylabel="y",
        zlabel="z",
        limits=((xmin,xmax),(ymin,ymax),(zmin,zmax))
    )
    scatter!(
        ax_particles,
        positions,
        markersize=8,
        color=:dodgerblue
    )

    # Histogram axis
    ax_hist = Axis(
        fig[1,2],
        title="Velocity Distribution",
        xlabel="Speed",
        ylabel="Probability Density"
    )
    hist!(
        ax_hist,
        hist_values,
        bins=60,
        normalization=:pdf,
        color=(:dodgerblue,0.5)
    )
    lines!(
        ax_hist,
        curve_x,
        curve_y,
        color=:red,
        linewidth=3
    )

    display(fig)

    # Compute the particle mechanics
    compute_forces!(p_array)
    while true

        # Use Verlet integration to update position and velocity
        # Save accelerations
        old_acc = [copy(p.force ./ p.mass) for p in p_array]

        # Update positions
        for (p,a) in zip(p_array, old_acc)
            p.pos .+= p.vel .* dt .+ 0.5 .* a .* dt^2
        end

        # Bounce off walls
        for p in p_array

            # Left/right walls
            if p.pos[1] < xmin
                p.pos[1] = xmin
                p.vel[1] *= -1
            elseif p.pos[1] > xmax
                p.pos[1] = xmax
                p.vel[1] *= -1
            end

            # Bottom/top walls
            if p.pos[2] < ymin
                p.pos[2] = ymin
                p.vel[2] *= -1
            elseif p.pos[2] > ymax
                p.pos[2] = ymax
                p.vel[2] *= -1
            end

            # Front/back walls
            if p.pos[3] < zmin
                p.pos[3] = zmin
                p.vel[3] *= -1
            elseif p.pos[3] > zmax
                p.pos[3] = zmax
                p.vel[3] *= -1
            end
        end

        # Recompute forces
        compute_forces!(p_array)

        # Finish velocity update
        for (p,a_old) in zip(p_array, old_acc)
            a_new = p.force ./ p.mass
            p.vel .+= 0.5 .* (a_old .+ a_new) .* dt
        end
        
        # Compute thermodynamic properties
        speeds = [norm(p.vel) for p in p_array]
        KE = sum(0.5 * p.mass * dot(p.vel, p.vel) for p in p_array)
        T = 2*KE/(3*length(p_array))   # Reduced temperature (kB = 1)

        # Print particle states
        #for i in 1:length(p_array)
        #    @printf("Iteration %d, Particle %d, Position: [%.6f, %.6f], Velocity: [%.6f, %.6f] \n", iter, i, p_array[i].pos[1], p_array[i].pos[2], p_array[i].vel[1], p_array[i].vel[2],)
        #end
        @printf("Iteration %d, Temperature %.9f \n", iter, T)

        # Update particle positions
        pts = positions[]
        for (i,p) in enumerate(p_array)
            pts[i] = Point3f(p.pos...)
        end
        notify(positions)

        # Update histogram
        q1 = quantile(speeds,0.10)
        q3 = quantile(speeds,0.90)
        iqr = q3-q1
        upper = q3 + 1.5*iqr
        filtered_speeds = filter(<=(upper), speeds)
        hist_values[] = filtered_speeds
        v = collect(range(
            0,
            maximum(filtered_speeds)+1e-6,
            length=200
        ))
        T_plot = mean(filtered_speeds.^2)/3
        curve_x[] = v
        curve_y[] = maxwell_boltzmann(v,T_plot)
        autolimits!(ax_hist)

        iter += 1
        sleep(dt / 100)
    end
end

simulate()