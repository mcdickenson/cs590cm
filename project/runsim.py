from sim import * 
import csv 
import threading
import time
import Queue
import os 


def runsim(datawriter=None, movies=[], rule="borda", w=0.5, n_nonmanip=5, prior=(1,1), perfect_info=False):
  p = Poll(movies=movies)

  manipulator = Agent(w=w)
  nonmanipvotes = []
  nonmanips = []
  for i in range(n_nonmanip):
    nonmanip = Agent(w = random.betavariate(prior[0], prior[1]) )
    nonmanips += [nonmanip]
    nonmanipvotes += [nonmanip.calcTruePrefs(movies)]

  manipulator_true_vote = manipulator.calcTruePrefs(movies)

  if perfect_info:
    manipulator_strat_vote = manipulator.calcManipulation(movies, rule=rule, nonmanipvotes=nonmanipvotes)
  else:
    manipulator_strat_vote = manipulator.calcManipulation(movies, rule=rule, prior=prior, count=n_nonmanip)

  # run true election
  vote_ary = [manipulator_true_vote] + nonmanipvotes
  tmp_poll = Poll(movies)
  tmp_winner = tmp_poll.run(vote_ary, rule=rule)

  for movie in movies:
    if movie.name == tmpwinner:
      true_winner_movie = movie 
  
  if manipulator_strat_vote == manipulator_true_vote:
    manipulation = False
    # run manipulated election
    vote_ary = [manipulator_strat_vote] + nonmanipvotes
    tmp_poll = Poll(movies)
    winner = tmp_poll.run(vote_ary, rule=rule)
  else:
    manipulation = True
    winner = tmp_winner

  for movie in movies:
    if movie.name == winner:
      winner_movie = movie 

  total_utils_in_true_manipulator = manipulator.calcUtil(true_winner_movie)
  total_utils_in_true = total_utils_in_true_maninpulator
  for nm in nonmanips:
    total_utils_in_true += nm.calcUtil(true_winner_movie)

  if manipulation:
    total_utils_manipulator = total_utils_in_true_maninpulator
    total_utils_in_outcome = total_utils_in_true
  else:
    total_utils_manipulator = manipulator.calcUtil(winner_movie)
    total_utils_in_outcome = total_utils_manipulator
    for nm in nonmanips:
      total_utils_in_outcome += nm.calcUtil(winner_movie)

  output = [ rule="borda", 
    n_nonmanip=5, 
    w=0.5, 
    prior[0],
    prior[1], 
    perfect_info=False
    manipulation,
    manipulator_strat_vote[0], 
    manipulator_strat_vote[1], 
    manipulator_strat_vote[3], 
    manipulator_strat_vote[4], 
    manipulator_strat_vote[5],
    winner,
    total_utils_in_outcome,
    total_utils_in_true,
    total_utils_manipulator,
    total_utils_in_true_manipulator,
  ]


class ThreadSim(threading.Thread):
  def __init__(self, threadID, q):
    self.threadID = threadID
    self.queue = q
    threading.Thread.__init__(self)

  def run(self):
    global data_writer
    print "Starting thread " + str(self.threadID)
    while not exitFlag:
      queueLock.acquire()
      if not workQueue.empty():
        seed = self.queue.get()
        queueLock.release()
        print "Running sim: rule={0}, w={1}, n={2}, perfect_info={3}, i={4}".format(seed['rule'], 
          seed['w'], 
          seed['n'], 
          seed['perfect_info'],
          seed['i'])

        runsim(datawriter=datawriter, 
          movies=movies, 
          rule=seed['rule'], 
          w=seed['w'],
          n_nonmanip=seed['n'], 
          prior=seed['prior'], 
          perfect_info=seed['perfect_info'])

      else:
        queueLock.release()
    print "Exiting thread " + str(self.threadID)

folder_name = "./data/"
t = ("%f" % time.time())[-6:]
data_filename = folder_name + "simdata-" + t + ".csv"
data_outfile = open(data_filename, 'w')
data_writer = csv.writer(data_outfile)

col_names = [ "rule", 
    "n_nonmanip", 
    "w", 
    "a", 
    "b",
    "perfect_info",
    "manipulation",
    "cand1", 
    "cand2", 
    "cand3", 
    "cand4", 
    "cand5", 
    "winner",
    "total_utils_in_outcome",
    "total_utils_in_true",
    "total_utils_manipulator",
    "total_utils_in_true_manipulator",
  ]

datawriter.writerow(col_names)
random.seed(8675309)
total_threads = 2
simulations_per_seed = 1

ca = Movie("Captain America", 0.89, 0.95)
n  = Movie("Noah",            0.77, 0.47)
d  = Movie("Divergent",       0.40, 0.78)
m  = Movie("Muppets",         0.79, 0.67)
gb = Movie("Grand Budapest",  0.92, 0.90)
movies  = [ca, n, d, m, gb]

rules = ["borda"]
ws = [0.1, 0.3, 0.5, 0.7, 0.9]
priors = [(9,1), (7,1), (5,1), (3,1), (1,1)]
ns = range(1,11)

simseeds = []
for rule in rules:
  for w in ws:
    for n in ns:
      for i in range(100):
        simseeds.append({
          'movies': movies,
          'rule': rule,
          'w': w,
          'n': n,
          'prior': (1,1),
          'perfect_info': True,
          'i': i
        })

for rule in rules:
  for w in ws:
    for prior in priors:
      for n in ns:
        for i in range(100):
          simseeds.append({
            'movies': movies,
            'rule': rule,
            'w': w,
            'n': n,
            'prior': prior,
            'perfect_info': False,
            'i': i
          })

workQueue = Queue.Queue()
queueLock = threading.Lock()
queueLock.acquire()
for seed in simseeds:
  workQueue.put(seed)
queueLock.release()

exitFlag = 0
threadList = range(total_threads)
threads = []
for t in threadList:
  thread = ThreadSim(t, workQueue)
  thread.start()
  threads.append(thread)

start = time.time()
while not workQueue.empty():
  pass
exitFlag = 1 # hey guys we're done!

for t in threads:
  t.join()

print "Threaded run took %s" % (time.time() - start)

data_outfile.close()




# datawriter=None, movies=[], rule="borda", w=0.5, n_nonmanip=5, prior=(1,1), perfect_info=False):


# p = Poll(movies=ary)

# a5 = Agent(w=0.5)
# a1 = Agent(w=0.1)
# a9 = Agent(w=0.9)

# a5.calcUtil(ca)
# a5.calcUtils(ary)
# a5.calcTruePrefs(ary)

# movies = ary




# vote = a5.calcManipulation(movies, rule=rule, nonmanipvotes=nonmanipvotes)
# print vote 
# print vote == a5.calcTruePrefs(movies)

    # nonmanipvotes = [a9.calcTruePrefs(ary)] * 2



  # a5 = Agent(w=0.5)
  # a1 = Agent(w=0.1)
  # a9 = Agent(w=0.9)

  # a5.calcUtil(ca)
  # a5.calcUtils(ary)
  # a5.calcTruePrefs(ary)


# vote = a5.calcManipulation(movies, rule=rule, nonmanipvotes=nonmanipvotes)
# print vote 
# print vote == a5.calcTruePrefs(movies)


# def calcManipulation(self, movies, rule="borda", nonmanipvotes=[], prior=(1,1), count=5):


# from sim import *
# ca = Movie("Captain America", 0.89, 0.95)
# n  = Movie("Noah",            0.77, 0.47)
# d  = Movie("Divergent",       0.40, 0.78)
# m  = Movie("Muppets",         0.79, 0.67)
# gb = Movie("Grand Budapest",  0.92, 0.90)

# ary = [ca, n, d, m, gb]
# p = Poll(movies=ary)

# a5 = Agent(w=0.5)
# a1 = Agent(w=0.1)
# a9 = Agent(w=0.9)

# a5.calcUtil(ca)
# a5.calcUtils(ary)
# a5.calcTruePrefs(ary)
