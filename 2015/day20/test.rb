#// Algo 1
# N = 34_000_000
# house = [0] * N
# 1.upto(N / 10) do |i|
#   (i..(N/10)).step(i) do |j|
#     house[j] += i * 10
#   end
# end

# house.each_with_index do |sum, i|
# 	raise i.to_s if sum >= N
# end

#for i = 1 .. N / 10
#    for j = i .. N / 10 in steps of i
#        house[j] += i * 10


#// Algo 1
N = 34_000_000
house = [0] * N
1.upto(N / 11) do |i|
  cnt = 0
  (i..(N / 11)).step(i) do |j|
    house[j] += i * 11
    cnt += 1
    break if cnt == 50
  end
end

house.each_with_index do |sum, i|
  raise i.to_s if sum >= N
end
