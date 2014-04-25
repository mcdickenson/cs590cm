import copy

class Movie(object):
  def __init__(self, name, critics, audience):
    self.name = name
    self.ratings = {"critics": critics, "audience": audience}

  def __repr__(self):
    return self.name

  def ratings(self):
    return self.ratings

  def name(self):
    return self.name


class Poll(object):
  def __init__(self, movies=[]):
    self.movies = movies
    self.votes = dict((m.name, 0) for m in movies)

  def __repr__(self):
    tmp = "["
    for m in self.movies:
      tmp += m.name
      tmp += ",\n"
    tmp += "]"
    return tmp

  def addBordaVote(self, preference_array):
    mx = len(preference_array)-1
    for p in preference_array:
      # nm = str(p)
      # self.votes[p] += mx
      self.votes[str(p)] += mx
      mx -= 1

  def addPluralityVote(self, preference_array):
    # nm = str(preference_array[0])
    # self.votes[preference_array[0].name] += 1
    self.votes[str(preference_array[0])] += 1

  def addVetoVote(self, preference_array):
    for p in preference_array[:-1]:
      self.votes[str(p)] += 1

  def addVote(self, preference_array, rule="borda"):
    if rule=="borda":
      self.addBordaVote(preference_array)
    elif rule=="plurality":
      self.addPluralityVote(preference_array)
    elif rule=="veto":
      self.addVetoVote(preference_array)
    else:
      raise "unknown voting rule"

  def addVotes(self, ary_of_pref_arys, rule="borda"):
    for pa in ary_of_pref_arys:
      self.addVote(pa, rule=rule)

  def getOutcome(self):
    sorted_movies = sorted(self.votes, key=self.votes.get, reverse=True)
    return sorted_movies
    # todo: name

  def run(self, votes, rule):
    self.addVotes(votes, rule=rule)
    outcome = self.getOutcome()
    return outcome[0]
    # todo: name


class Agent(object):
  def __init__(self, w=0.5):
    self.w = w 

  def calcUtil(self, movie):
    util  = self.w * movie.ratings["critics"]  
    util += (1-self.w) * movie.ratings["audience"]
    return util 

  def calcUtils(self, movies):
    return list(self.calcUtil(m) for m in movies)

  def mostPreferred(self, movies):
    tmp = sorted_utils
    return tmp[0]

  def calcTruePrefs(self, movies):
    utils = dict((m, self.calcUtil(m)) for m in movies)
    sorted_utils = sorted(utils, key=utils.get, reverse=True)
    # print "sorted_utils:"
    # print sorted_utils
    return sorted_utils

  def getNonmanipVotes(self, movies, prior, count):
    mle = float(prior[0])/float(prior[0]+prior[1])
    fake = Agent(w=mle)
    prefs = fake.calcTruePrefs(movies)
    return [prefs]*count

  def calcManipulation(self, movies, rule="borda", nonmanipvotes=[], prior=(1,1), count=5):
    if len(nonmanipvotes)==0:
      nonmanipvotes = self.getNonmanipVotes(movies, prior, count)
    # get normal winner
    true_prefs = self.calcTruePrefs(movies)
    vote_ary = [true_prefs] + nonmanipvotes
    tmp_poll = Poll(movies)
    normal_winner = tmp_poll.run(vote_ary, rule=rule)
    for m in movies:
      if m.name == normal_winner:
        normal_winner_movie = m 
    # check whether the candidate wants the normal winner
    if normal_winner== true_prefs[0].name:
      return true_prefs # no incentive to manipulate

    expressed_prefs = true_prefs
    expressed_prefs_utils = self.calcUtil(normal_winner_movie)
    # find manipulation
    for movie in movies:
      if movie.name == normal_winner:
        continue
      # formulate a vote in which manipulator puts this movie first and 'normal winner' last
      tmp_movies = copy.deepcopy(movies)
      # tmp_movies.remove(movie)
      for m in tmp_movies:
        if (m.name == normal_winner) or (m.name == movie.name):
          tmp_movies.remove(m)
      # tmp_movies.remove(normal_winner)
      middle_prefs = self.calcTruePrefs(tmp_movies)
      # strat_prefs = [true_prefs[0]] + middle_prefs + [normal_winner]
      strat_prefs = [movie] + middle_prefs + [normal_winner]
      # print "strat_prefs"
      # print strat_prefs
      # run the rule
      vote_ary = [strat_prefs] + nonmanipvotes
      tmp_poll = Poll(movies)
      # print tmp_poll
      tmp_winner = tmp_poll.run(vote_ary, rule=rule)
      for m in movies:
        if m.name == tmp_winner:
          tmp_winner_movie = m 
      if self.calcUtil(tmp_winner_movie) > expressed_prefs_utils:
        expressed_prefs = strat_prefs 
        expressed_prefs_utils = self.calcUtil(tmp_winner_movie)
    return expressed_prefs


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

# movies = ary
# rule = "borda"
# nonmanipvotes = [a9.calcTruePrefs(ary)] * 2
# vote = a5.calcManipulation(movies, rule=rule, nonmanipvotes=nonmanipvotes)
# print vote 
# print vote == a5.calcTruePrefs(movies)
