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

# ╔═╡ 9ed22b10-2023-11eb-185d-1b43278ebd5c
using Plots, PlutoUI

# ╔═╡ 7c6dc900-20f8-11eb-052c-334c963dfb5e
mutable struct blob
	x::Float64
	y::Float64
	dx::Float64
	dy::Float64
	state::String
end

# ╔═╡ 9deae3a0-20b8-11eb-00eb-217daead6c44
begin
	# helper functions
	function uniform(radius) radius * rand(Float64) * rand([-1, 1]) end
	function dist(a, b) sqrt((b.x - a.x)^2 + (b.y - a.y)^2) end
	function pullx(blob) blob.x end
	function pully(blob) blob.y end
	"done!"
end

# ╔═╡ 30022fb0-21bc-11eb-1aff-01acdb1f6a71
begin
	function blobchangedir(blob, step)
		blob.dx, blob.dy = rand([-step, 0, step]), rand([-step, 0, step])
	end
	function blobstep(blob) 
		blob.x, blob.y = blob.x + blob.dx, blob.y + blob.dy 
	end
	"done!"
end

# ╔═╡ 1288267e-202a-11eb-00ff-07c7f4eb472c
function simulate(iterations, P, I0, r, β, γ, bound, δ, T)
	S = [[blob(uniform(bound), uniform(bound), 0, 0, "susceptible") for i in 1:P-I0]]
	I = [[blob(uniform(bound), uniform(bound), 0, 0, "infectious") for i in 1:I0]]
	R = [[]]
	blobchangedir.(S[1], δ)
	blobchangedir.(I[1], δ)
	blobchangedir.(R[1], δ)
	for i in 1:iterations
		sus, inf, rem = deepcopy(S[i]), deepcopy(I[i]), deepcopy(R[i])
		newsus, newinf = Any[], Any[]
		if i % T == 0
			blobchangedir.(sus, δ)
			blobchangedir.(inf, δ)
			blobchangedir.(rem, δ)
		end
		blobstep.(sus)
		blobstep.(inf)
		blobstep.(rem)
		for i in 1:length(inf)
			for j in 1:length(sus)
				close = dist(inf[i], sus[j]) <= r
				susceptible = sus[j].state == "susceptible"
				bool = rand() <= β
				if (susceptible & close & bool) sus[j].state = "infectious" end
			end
		end
		for blob in inf
			append!(if (rand() <= γ) rem else newinf end, [blob])
		end
		for blob in sus
			append!(if (blob.state == "infectious") newinf else newsus end, [blob])
		end
		append!(S, [newsus])
		append!(I, [newinf])
		append!(R, [rem])
	end
	S, I, R
end

# ╔═╡ caa833f2-21aa-11eb-330a-65620975e0cd
# blobs on scatterplot
function showblobs(S, I, R, iteration)
	map = scatter(pullx.(S[iteration]), 
		      pully.(S[iteration]), 
		      grid=false,  
		      color=RGB(0, 1, 0),
		      labels=false,
		      axis=false)
	scatter!(map, pullx.(I[iteration]),
		      pully.(I[iteration]),
		      grid=false,
		      axis=nothing,
		      color=RGB(1, 0, 0),
		      labels=false)
	scatter!(map, pullx.(R[iteration]),
		      pully.(R[iteration]),
		      grid=false,
		      axis=nothing,
		      color=RGB(0.5, 0.5, 0.5),
		      labels=false)
	map
end

# ╔═╡ fd6feda0-21aa-11eb-31bc-c7128afe551a
# show the SIR among blobs
function showplots(S, I, R, iteration)
	pop = plot(1:iteration, 
		   length.(S[1:iteration]),  
		   color=RGB(0, 1, 0),
	           linewidth=2,
		   grid=false,
		   labels=false,
		   axis=nothing)
	plot!(pop, 1:iteration,
		   length.(I[1:iteration]),
		   color=RGB(1, 0, 0),
		   linewidth=2,
		   labels=false)
	plot!(pop, 1:iteration,
		   length.(R[1:iteration]),
		   color=RGB(0.5, 0.5, 0.5),
		   linewidth=2,
		   labels=false)
	pop
end

# ╔═╡ e713c990-21ab-11eb-2c89-231f3ab0ac61
@bind iterations Slider(1:500; default=200, show_value=true) # iterations

# ╔═╡ ea0f5650-21ab-11eb-1e19-b1c7e9d14aec
@bind P Slider(10:300; default=50, show_value=true) # population

# ╔═╡ e9a71ea0-21ab-11eb-0da2-f197724951df
@bind I0 Slider(1:P; default=1, show_value=true) # initial infections

# ╔═╡ e946fd40-21ab-11eb-2ff4-ffd7b0eda2ca
@bind β Slider(0:0.1:1; default=0.3, show_value=true) # infection rate

# ╔═╡ e8dfd700-21ab-11eb-0db0-f33d301e9c6f
@bind γ Slider(0:0.01:1; default=0.1, show_value=true) # removal rate

# ╔═╡ e8a87350-21ab-11eb-1046-698af4185b85
@bind bound Slider(1:100; default=20, show_value=true) # map size

# ╔═╡ e96cfbd0-21ab-11eb-13e5-3543e0e272d1
@bind r Slider(0:0.1:bound; default=1, show_value=true) # infection radius

# ╔═╡ 180f009e-21ac-11eb-184b-bf1e1f6daad2
@bind δ Slider(0.01:0.01:0.5; default=0.1, show_value=true) # blob mobility

# ╔═╡ fcb404c2-21b7-11eb-36b5-0578ceecec98
@bind T Slider(1:50; default=1, show_value=true) # time period of direction change

# ╔═╡ cec42f60-21ab-11eb-0dc2-bbf580692abd
begin
	S0 = P - I0
	S, I, R = simulate(iterations, P, I0, r, β, γ, bound, δ, T)
	"done!"
end

# ╔═╡ ba12a380-21ab-11eb-20c3-fb7216fad532
showblobs(S, I, R, iteration)

# ╔═╡ a36663a0-21ac-11eb-1618-eb410ee37272
@bind iteration Slider(1:iterations; default=1, show_value=true)

# ╔═╡ a8de0960-21ab-11eb-156f-ef670133cd11
showplots(S, I, R, iteration)

# ╔═╡ Cell order:
# ╠═9ed22b10-2023-11eb-185d-1b43278ebd5c
# ╠═7c6dc900-20f8-11eb-052c-334c963dfb5e
# ╠═9deae3a0-20b8-11eb-00eb-217daead6c44
# ╠═30022fb0-21bc-11eb-1aff-01acdb1f6a71
# ╠═1288267e-202a-11eb-00ff-07c7f4eb472c
# ╠═caa833f2-21aa-11eb-330a-65620975e0cd
# ╠═fd6feda0-21aa-11eb-31bc-c7128afe551a
# ╠═e713c990-21ab-11eb-2c89-231f3ab0ac61
# ╠═ea0f5650-21ab-11eb-1e19-b1c7e9d14aec
# ╠═e9a71ea0-21ab-11eb-0da2-f197724951df
# ╠═e96cfbd0-21ab-11eb-13e5-3543e0e272d1
# ╠═e946fd40-21ab-11eb-2ff4-ffd7b0eda2ca
# ╠═e8dfd700-21ab-11eb-0db0-f33d301e9c6f
# ╠═e8a87350-21ab-11eb-1046-698af4185b85
# ╠═180f009e-21ac-11eb-184b-bf1e1f6daad2
# ╠═fcb404c2-21b7-11eb-36b5-0578ceecec98
# ╠═cec42f60-21ab-11eb-0dc2-bbf580692abd
# ╠═ba12a380-21ab-11eb-20c3-fb7216fad532
# ╠═a36663a0-21ac-11eb-1618-eb410ee37272
# ╠═a8de0960-21ab-11eb-156f-ef670133cd11
