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
# population
@bind P Slider(100:500; show_value=true) 

# ╔═╡ 55970f80-1f9a-11eb-2828-7f2b9c0bb616
# rate of infection
@bind β Slider(0.01:0.01:1; default=0.4, show_value=true) 

# ╔═╡ 552fe940-1f9a-11eb-0b7f-19721da9031d
# rate of recovery/death/quarantine
@bind γ Slider(0.01:0.01:0.5; default=0.04, show_value=true) 

# ╔═╡ 7a6b2ad0-1ffe-11eb-30f8-7d27273310ae
# step size
@bind dt Slider(0.01:0.01:0.2; default=0.1, show_value=true) 

# ╔═╡ 1ab36212-1ffe-11eb-155c-9ba7301bdfdc
# initial infections
@bind I0 Slider(1:P; default=3, show_value=true) 

# ╔═╡ 33e4f640-1f9a-11eb-0853-4171c33f3b72
function simulate(β, γ, dt, I, R, P, iterations)
	S = P - I0
	SIR = zeros(iterations, 3)
	for i in 1:iterations
		dS, dI, dR = - β * S * I * dt / P, ((β * S * I / P) - γ * I) * dt, γ * I * dt
		S, I, R = S + dS, I + dI, R + dR
		SIR[i, 1], SIR[i, 2], SIR[i, 3] = S, I, R
	end
	return SIR
end

# ╔═╡ b3ff5830-21e7-11eb-1c5a-85796b589bd1
@bind iterations Slider(1:400; default=1, show_value=true)

# ╔═╡ d64214b0-1fa2-11eb-054f-c78bb7311a43
begin 
	SIR = simulate(β, γ, dt, I0, 0, P, iterations)
	S, I, R = SIR[:, 1], SIR[:, 2], SIR[:, 3]
	string("Population = ", sum(SIR[iterations, :]), " = constant")
end

# ╔═╡ 581d4b90-1fa2-11eb-1138-a5cfa4e8de7c
begin
	p = plot(1:iterations, S, label=false, linewidth=2, grid=false, color=RGB(1, 0.7, 0), axis=nothing)
	plot!(p, 1:iterations, I, label=false, linewidth=2, grid=false, color=RGB(1, 0, 0), axis=nothing)
	plot!(p, 1:iterations, R, label=false, linewidth=2, grid=false, color=RGB(0, 0.65, 1), axis=nothing)
end

# ╔═╡ Cell order:
# ╠═9bdc55d0-1f82-11eb-2fae-4957d857b9b8
# ╠═73ce5b70-1ffe-11eb-3dcb-857ff41d1c27
# ╠═55970f80-1f9a-11eb-2828-7f2b9c0bb616
# ╠═552fe940-1f9a-11eb-0b7f-19721da9031d
# ╠═7a6b2ad0-1ffe-11eb-30f8-7d27273310ae
# ╠═1ab36212-1ffe-11eb-155c-9ba7301bdfdc
# ╠═33e4f640-1f9a-11eb-0853-4171c33f3b72
# ╠═d64214b0-1fa2-11eb-054f-c78bb7311a43
# ╠═b3ff5830-21e7-11eb-1c5a-85796b589bd1
# ╠═581d4b90-1fa2-11eb-1138-a5cfa4e8de7c
