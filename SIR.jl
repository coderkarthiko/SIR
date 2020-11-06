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

# ╔═╡ 73ce5b70-1ffe-11eb-3dcb-857ff41d1c27
@bind N Slider(100:100000; show_value=true) # population

# ╔═╡ 55970f80-1f9a-11eb-2828-7f2b9c0bb616
@bind β Slider(0.01:0.01:0.5; show_value=true) # rate of infection

# ╔═╡ 552fe940-1f9a-11eb-0b7f-19721da9031d
@bind γ Slider(0.01:0.01:0.5; show_value=true) # rate of removal

# ╔═╡ 7a6b2ad0-1ffe-11eb-30f8-7d27273310ae
@bind dt Slider(0.001:0.001:0.1; show_value=true) # step size

# ╔═╡ 1ab36212-1ffe-11eb-155c-9ba7301bdfdc
@bind initinf Slider(1:N; show_value=true) # initial infections

# ╔═╡ 89106780-1ffe-11eb-1273-4b5e501ec7ac
initsus = N - initinf # initial susceptible

# ╔═╡ 33e4f640-1f9a-11eb-0853-4171c33f3b72
function simulate(β, γ, dt, S, I, R, N, iterations)
	SIR = zeros(iterations, 3)
	for i in 1:iterations
		dS, dI, dR = - β * S * I * dt / N, ((β * S * I / N) - γ * I) * dt, γ * I * dt
		S, I, R = S + dS, I + dI, R + dR
		SIR[i, 1], SIR[i, 2], SIR[i, 3] = S, I, R
	end
	return SIR
end

# ╔═╡ 5c7812d0-1fa5-11eb-00c1-338699dbfa06
@bind iterations Slider(1:10000; show_value=true)

# ╔═╡ d64214b0-1fa2-11eb-054f-c78bb7311a43
begin 
	SIR = simulate(β, γ, dt, initsus, initinf, 0, N, iterations)
	S, I, R = SIR[:, 1], SIR[:, 2], SIR[:, 3]
	string("Population = ", sum(SIR[iterations, :]), " = constant")
end

# ╔═╡ 581d4b90-1fa2-11eb-1138-a5cfa4e8de7c
begin
	p = plot(1:iterations, S, label="susceptible", linewidth=2, grid=false, 		                xlabel="time", ylabel="SIR population")
	plot!(p, 1:iterations, I, label="infectious", linewidth=2, grid=false)
	plot!(p, 1:iterations, R, label="removed", linewidth=2, grid=false)
	plot!(p, 1:iterations, S + I + R, label="population", linewidth=2, grid=false)
end

# ╔═╡ Cell order:
# ╠═9bdc55d0-1f82-11eb-2fae-4957d857b9b8
# ╠═73ce5b70-1ffe-11eb-3dcb-857ff41d1c27
# ╠═55970f80-1f9a-11eb-2828-7f2b9c0bb616
# ╠═552fe940-1f9a-11eb-0b7f-19721da9031d
# ╠═7a6b2ad0-1ffe-11eb-30f8-7d27273310ae
# ╠═1ab36212-1ffe-11eb-155c-9ba7301bdfdc
# ╠═89106780-1ffe-11eb-1273-4b5e501ec7ac
# ╠═33e4f640-1f9a-11eb-0853-4171c33f3b72
# ╠═5c7812d0-1fa5-11eb-00c1-338699dbfa06
# ╠═d64214b0-1fa2-11eb-054f-c78bb7311a43
# ╠═581d4b90-1fa2-11eb-1138-a5cfa4e8de7c
