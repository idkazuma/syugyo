
#   - b - d - f
# a   |   |
#   - c - e - g
#
#   - 1 - 3 - 5
# 0   |   |
#   - 2 - 4 - 6
#

START=0

GOAL=6
Loadmap=[]
"12,023,014,145,236,3,4".split(",").each do |x|
#   loadmap.push(x.split(//).to_s)
  Loadmap.push(x.split(//))
end

# p loadmap[0]
# puts load

def search_test(goal, paths)
  now = paths[paths.size-1].to_i
  if now == goal
    p paths
  else
    # p paths
    # p Loadmap[now]
    # p Loadmap[now]
    Loadmap[now].each do |n|
     if !paths.include? n
       # puts n
       paths.push n
       search_test GOAL, paths
       paths.pop
     end
   end
  end
#   # paths[paths.len
#   # puts paths.len
end

def bfs(start, goal)
  # enqueue
  q=[[start.to_s]]
  while q.size > 0
    # dequeue
    paths = q.shift
    now = paths[paths.size-1].to_i
    if now == goal
      p paths
      # uncomment when need just only one
      # return
    else
      Loadmap[now].each do |n|
        if !paths.include? n
          newpaths = Marshal.load(Marshal.dump(paths))
          newpaths.push n
          # enqueue
          q.push newpaths
        end
      end
    end
  end
end


# search_test(GOAL, ["0"])
bfs(START, GOAL)

