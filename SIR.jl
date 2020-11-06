### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 9bdc55d0-1f82-11eb-2fae-4957d857b9b8
using Plots, PlutoUI

# ╔═╡ a4bd46d0-1f98-11eb-395e-55c08e663cc3
# I'm very new to Julia!
# I've never implemented a differential equation model before
# Let's see how quickly I can implement the SIR epidemic model

# SIR model - S -> Susceptible, I -> Infected, R -> Removed
# dS/dt = -bSI
# dI/dt = bSI - gI 
# dR/dt = gI
# dS/dt + dI/dt + dR/dt = 0 'cause S + I + R = P = total population constant

# ╔═╡ 458a41a0-1f9c-11eb-324d-737f3b113d1c
@bind P Slider(100:10000; show_value=true)

# ╔═╡ 95fd3250-1f9c-11eb-0841-bd3230e0acef
@bind initinf Slider(1:P; show_value=true)

# ╔═╡ 55970f80-1f9a-11eb-2828-7f2b9c0bb616
@bind β Slider(0.01:0.01:0.2; show_value=true) # rate of infection?

# ╔═╡ 552fe940-1f9a-11eb-0b7f-19721da9031d
@bind γ Slider(0.01:0.01:0.2; show_value=true) # rate of death or cure

# ╔═╡ 72604af0-1f9a-11eb-2da6-2d9d214a8370
@bind dt Slider(0.001:0.001:0.1; show_value=true)

# ╔═╡ adc53b12-1f9e-11eb-07d5-bd764771163e
initS = P - initinf

# ╔═╡ 33e4f640-1f9a-11eb-0853-4171c33f3b72
function simulate(β, γ, dt, S, I, R, iterations)
	arr = zeros(iterations, 3)
	for i in 1:iterations
		dS, dI, dR = - β * S * I * dt, (β * S * I - γ * I) * dt, γ * I * dt
		S, I, R = S + dS, I + dI, R + dR
		arr[i, 1], arr[i, 2], arr[i, 3] = S, I, R
	end
	return arr # S, I, R
end

# ╔═╡ 5c7812d0-1fa5-11eb-00c1-338699dbfa06
@bind iterations Slider(1:5000; show_value=true)

# ╔═╡ d64214b0-1fa2-11eb-054f-c78bb7311a43
begin 
	SIRs = simulate(β, γ, dt, initS, initinf, 0, iterations)
	sus, inf, rem = SIRs[:, 1], SIRs[:, 2], SIRs[:, 3]
	sum(SIRs[iterations, :]) # susceptible + infection + removed = P = constant
end

# ╔═╡ 581d4b90-1fa2-11eb-1138-a5cfa4e8de7c
begin
	p = plot(1:iterations, sus, label="susceptible", linewidth=2, grid=false)
	plot!(p, 1:iterations, inf, label="infectious", linewidth=2, grid=false)
	plot!(p, 1:iterations, rem, label="removed", linewidth=2, grid=false)
	plot!(p, 1:iterations, sus + inf + rem, label="P", linewidth=2, grid=false)
end

# ╔═╡ Cell order:
# ╠═a4bd46d0-1f98-11eb-395e-55c08e663cc3
# ╠═9bdc55d0-1f82-11eb-2fae-4957d857b9b8
# ╠═458a41a0-1f9c-11eb-324d-737f3b113d1c
# ╠═95fd3250-1f9c-11eb-0841-bd3230e0acef
# ╠═55970f80-1f9a-11eb-2828-7f2b9c0bb616
# ╠═552fe940-1f9a-11eb-0b7f-19721da9031d
# ╠═72604af0-1f9a-11eb-2da6-2d9d214a8370
# ╠═adc53b12-1f9e-11eb-07d5-bd764771163e
# ╠═33e4f640-1f9a-11eb-0853-4171c33f3b72
# ╠═5c7812d0-1fa5-11eb-00c1-338699dbfa06
# ╠═d64214b0-1fa2-11eb-054f-c78bb7311a43
# ╠═581d4b90-1fa2-11eb-1138-a5cfa4e8de7c
