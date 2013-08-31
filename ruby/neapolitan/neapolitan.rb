#! /usr/bin/env ruby

s="gtgtsgipgttptinggipsppaigsesgpetgstpatetisiesagaeaigttetepitiatsegssieeeeatepaaiagtpieataatppiitgiapsteitatiiatpetetetttgpetpaasipttssstpeeeggtiagtttegtiipestsasgpsepaasapttgattgiatppegitiatpasgatgepttggapesaeetaeissttggieietgspagesiipestipggstttpateptitiaetottissgggtttaipappgstsptttgtpispattgegstltiappseisapgistaiagteeiptptpisaieisagstapeteietgteiisgtiptstgtstasspeatspptitttatteastsgtptgtasggpniaaeteaisett"
n='neapolitan'.split(//)

i=0
a=""

# s.split(//).each{|x|n[i]==x ?(i+=1;a<<"[#{x}]"):a<<x}
s.split(//).each{|x|a<<(n[i]==x ?(i+=1;"[#{x}]"):x)}

# s.split(//).each do |x|
#   if n[i]==x
#     i+=1
#     a<<"[#{x}]"
#   else
#     a<<x
#   end
# end

print a


