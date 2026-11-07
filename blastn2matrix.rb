
samples=[]
gen=[]
hsamples={}
hgen={}
sample=''


`ls #{ARGV[0]} | sed 's/blastn_//g' | sed 's/.txt//g' > list_samples.txt`

listado=File.new("blastn_all.txt","w")

aa=File.open("list_samples.txt").each_line do |file|
file.chomp!
sample=file.split("\.")[0]
samples << sample
#NODE_4_length_281663_cov_152.962804     blaADC-25_1_EF016355    97.309  1152    31      0       108888  110039  1152    1       0.0     1956    1152    TTATTTCTTTATTGCAC
#18ac5dd7-4e83-4653-b37f-2a70e6f5d444    lnu(A)_1_M14039 94.652  187     6       4       233     415     486     300     3.54e-78        287     486     TTA
#d418fc25-22c4-410d-b565-a8baaff13328    blaVIM-48_1_KY362199    100.000 36      0       0       934     969     775     810     3.76e-11        67.6    810     GGCTCTGTTGCAAAGATTGGCGGCAGTCAGAGGTAG
bb=File.open("#{ARGV[0]}/blastn_#{file}.txt").each_line do |line|
line.chomp!
col=line.split("\t")
puts col[12].to_f/col[3].to_f
if col[2].to_f > 80 and 100*col[3].to_f/col[12].to_f > 80
gen << col[1].split("\_")[0]
puts line
end
end
bb.close
end
aa.close
########### 	To not miss samples with no blast results:

gen=gen.uniq	
samples.each_index{|a| hsamples[samples[a]] = a}	
gen.each_index{|a| hgen[gen[a]] = a}	
matrix = Array.new(gen.length()) {|index| Array.new(samples.length()) {|x| 0}}

########### 

aa=File.open("list_samples.txt").each_line do |file|
file.chomp!
sample=file.split("\.")[0]
bb=File.open("#{ARGV[0]}/blastn_#{file}.txt").each_line do |line|
line.chomp!
col=line.split("\t")
if col[2].to_f > 80 and 100*col[3].to_f/col[12].to_f > 80
matrix[hgen[line.split("\t")[1].split("\_")[0]]][hsamples[sample]]+=1
listado.puts "#{file}\t#{line}"
end
end
bb.close
end
aa.close

################################################# Ordena la tabla para colocar las unknown functions al final ##################

# lo de escribir la matriz es copia-pega de internet, alguna 

output=File.new("matrix_Resfinder_v2.txt","w")

mm=-1
samples.each {|i| output.print "\t#{i}"}
output.print "\n"
matrix.each {|i|  mm+=1
output.print "#{gen[mm]}"
i.each {|value| output.print "\t#{value}"}
output.print "\n"
}

