# Julia program that attempts to solve the BoxWorld problem by
# getting user input defining a goal and designing a layout
# using various heuristics/ search algorithms

function BlocksWorld(gettingAllActions)

argType=["variable","terminal"]

checkArg=["positive","negative"]

propositionList=["on","ontable","clear","hold","empty"]
actionList=[]
blocks=[]

    gettingAllActions()
	preconditionList=[]
	effectList=[]
	preconditionList.append(Sentence(propositionList[1],[Argument("block",argType[0], 0)],0))
	preconditionList.append(Sentence(propositionList[2],[Argument("block",argType[0],0)],0))
	preconditionList.append(Sentence(propositionList[4], [],0))
	effectList.append(Sentence(propositionList[3],[Argument("block",argType[0],0)],0))
	effectList.append(Sentence(propositionList[2],[Argument("block",argType[0],0)], 1))
	effectList.append(Sentence(propositionList[1],[Argument("block",argType[0],0)], 1))
	effectList.append(Sentence(propositionList[4], [], 1))

	actionList.append(Action("pick", ["block"],preconditionList,effectList))

	preconditionList=[]
	effectList=[]

	preconditionList.append(Sentence(propositionList[0],[Argument("blocka",argType[0], 0),Argument("blockb",argType[0], 0)],0))
	preconditionList.append(Sentence(propositionList[2],[Argument("blocka",argType[0], 0)],0))
	preconditionList.append(Sentence(propositionList[4], [],0))
	effectList.append(Sentence(propositionList[3],[Argument("blocka",argType[0],0)],0))
	effectList.append(Sentence(propositionList[2],[Argument("blockb",argType[0],0)], 0))
	effectList.append(Sentence(propositionList[0],[Argument("blocka",argType[0],0),Argument("blockb",argType[0],0)], 1))
	effectList.append(Sentence(propositionList[2],[Argument("blocka",argType[0], 0)],1))
	effectList.append(Sentence(propositionList[4], [], 1))

	actionList.append(Action("unstack",["blocka","blockb"], preconditionList, effectList))

	preconditionList=[]
	effectList=[]

	preconditionList.append(Sentence(propositionList[3],[Argument("block",argType[0],0)],0))
	effectList.append(Sentence(propositionList[1],[Argument("block",argType[0],0)], 0))
	effectList.append(Sentence(propositionList[2],[Argument("block",argType[0],0)], 0))
	effectList.append(Sentence(propositionList[3],[Argument("block",argType[0],0)],1))
	effectList.append(Sentence(propositionList[4], [], 0))

	actionList.append(Action("release",["block"], preconditionList, effectList))

	preconditionList=[]
	effectList=[]

	preconditionList.append(Sentence(propositionList[2],[Argument("blockb",argType[0], 0)],0))
	preconditionList.append(Sentence(propositionList[3],[Argument("blocka",argType[0],0)],0))
	effectList.append(Sentence(propositionList[0],[Argument("blocka",argType[0],0),Argument("blockb",argType[0],0)], 0))
	effectList.append(Sentence(propositionList[2],[Argument("blocka",argType[0],0)], 0))
	effectList.append(Sentence(propositionList[3],[Argument("blocka",argType[0],0)],1))
	effectList.append(Sentence(propositionList[2],[Argument("blockb",argType[0],0)], 1))
	effectList.append(Sentence(propositionList[4], [], 0))

	actionList.append(Action("stack",["blocka","blockb"], preconditionList, effectList))
	#print actionList
    aStar(initialState,goalState)

	queue=[]
	noOfExpandedNodes=0
	heappush(queue,(initialState.depth+initialState.heuristic,initialState))

	while queue
		currHeapElement=heappop(queue)
		currState=currHeapElement[1]
		#print "curr",str(currState)
		if currState.isGoal(goalState)
			return noOfExpandedNodes,currState
		end
		#print 'currState'
		#print str(currState)
		noOfExpandedNodes=noOfExpandedNodes+1
		newStateList=currState.getNewState()
		#for newState in newStateList:
		#	print "neighbours:"+str(newState)
		#sys.exit(0)
		#for neighborState in newStateList:
		#	print 'neighbouts'
		#	print str(neighborState)
	end
		for newState in newStateList
			newState.prevState=currState
			newState.depth=currState.depth + 1
			newState.assigningHeuristic(goalState)

			heappush(queue,(newState.depth+newState.heuristic,newState))

	return -1,-1
end


    gsp(startState, goalState)

	planList = []
	stack = []
	currentState = State(startState.sentenceList, startState.groundList)

	stack.append(goalState.sentenceList)
	for sentence in goalState.sentenceList
		stack.append([sentence])

	while stack
		# print("***new***")
		# printList(stack)
		poppedElement = stack.pop()

		if type(poppedElement) == list

			if not currentState.hasSentence(poppedElement)

				if len(poppedElement) > 1
					stack.append(poppedElement)
					random.shuffle(poppedElement)
					for sentence in poppedElement
						stack.append([sentence])
					end

				else
					newGoalsData = poppedElement[0].getNewGoals(currentState)
				end

					if newGoalsData == None
						stack = []
						currentState = State(startState.sentenceList,
								startState.groundList)
						planList = []
						stack.append(goalState.sentenceList)
						for sentence in goalState.sentenceList
							stack.append([sentence])
						continue
					end
				end

					actionDict = dict()
					actionDict["action"] = newGoalsData["action"]
					actionDict["assignment"] = newGoalsData["assignment"]
					stack.append(actionDict)
					stack.append(newGoalsData["sentenceList"])
					for sentence in newGoalsData["sentenceList"]
						stack.append([sentence])
					end

		else
			action = poppedElement["action"]
			assignment = poppedElement["assignment"]
			currentState = getStates(currentState,action, assignment)
			planList.append(poppedElement)
			# printDict(poppedElement)
		end

	return planList
end

       Action(init, str)

	   init(self,name,args,preconditionList,effectList)

		self.name = name
		self.arguments = args
		self.preconditionList = list(preconditionList)
		self.effectList = list(effectList)
		self.variableList = []

		for precondition in preconditionList
			for arg in precondition.arguments
				flag=0
				for varArg in self.variableList
				if flag==0
					self.variableList.append(arg)
				end
			end
		end

	 str(self)

		string=""
		string=string+"Action: "+self.name +"\n"+"Precondition: "
		for conjucts in self.preconditionList
			string=string+str(conjucts)
		string=string+"\n"+"Effect"
	end
		for conjucts in self.effectList
			string=string+str(conjucts)
		string=string+"\n"
		return string
	end
	end

        State(init, str)

	    init(self, sentenceList, groundList)
		self.sentenceList = list(sentenceList)
		self.groundList = list(groundList)
		self.depth = 0
		self.heuristic = 0
		self.prevState = None
		self.prevActionInstr = ""


	    str(self)
		string=""
		for sentence in self.sentenceList
			string=string+str(sentence)+"\n"
		string=string+"Previous Action : "+self.prevActionInstr+"\n"#+str(self.prevAction)

		return string
	end
	end

	    isGoal(self, goalState, heuristicValue=0)

		if not heuristicValue

			first=self.sentenceList
			second=goalState.sentenceList
			if not len(first) == len(second)
				return 0
			end

			dupFirst = list(first)
			dupSecond = list(second)
		end

			for item in dupFirst
				flag = 0
				itemInList = None

				if flag==0
					return 0
				end

				dupSecond.remove(itemInList)
			end

			return 1
		end

	    getNewState(self, heuristicValue=0)

		newList = []

		for action in actionList
			newList.extend(getStatesOnAction(self,action,[],heuristicValue))

		return newList
	end

	    assigningHeuristic(self, goalState)

		currState = State(self.sentenceList, self.groundList)
		goalSentence=list(goalState.sentenceList)
		count = 0
		while (1<2)
			for action in actionList
				stateList=getStatesOnAction(currState,action,[],[],1)
				#print "states are"
				#for i in stateList:
				#	print str(i)+"\n\n\n"
				#sys.exit(0)
				if stateList
					currState=stateList[0]

				count=count+1
			end
				#print "outside"
				if currState.hasSentence(goalSentence)
					#print "inside"
					#sys.exit(0)
					self.heuristic=count
					return
				end
		# self.heuristic = currState.heuristic
		self.heuristic = count
end
	    getPathtoGoal(self)
		currState=self
		allPath=[]
		while currState
			allPath.append(currState)
			currState=currState.prevState

		return allPath
	end
end
function Argument()

	 init(self,argValue,argType,isPositive,)

		self.argType = argType
		self.argValue = argValue
		self.isPositive = isPositive

	    str(self)

		string=""
		if self.isPositive==1
			string=string+"~"
		string=string+str(self.argValue)
		return string
	end
end
    getStates(stateObj,actionObj,assignment,heuristicValue=0)
	newState = State(stateObj.sentenceList,stateObj.groundList)
	for trueSentence in actionObj.effectList
		newTrueSentence = Sentence(trueSentence.propositionType, [],0)
		groundList = []
		for variable in trueSentence.arguments
			savedArg = assignment[variable.argValue]
			groundList.append(savedArg)
		end

		newTrueSentence.arguments = groundList
	end
		if trueSentence.isPositive
			if not heuristicValue
				#newState.removeTrueSentence(newTrueSentence)
				temp=[]
				for sentence in newState.sentenceList
					if (newTrueSentence.propositionType!=sentence.propositionType || newTrueSentence.isPositive!=sentence.isPositive || not(compareList(list(sentence.arguments),list(newTrueSentence.arguments))))
						temp.append(sentence)
					end
				newState.sentenceList=temp
			end

		else
			addSentence(newState,newTrueSentence)
		end
	if heuristicValue
		newState.heuristic = stateObj.heuristic + 1
	argumentsString = ""
end
	for arg in actionObj.arguments
		argumentsString += " " + str(assignment[arg])

	newState.prevActionInstr = "(" + actionObj.name + argumentsString + ")"

	return newState
end

if len(sys.argv) < 2
	print("Invalid/insufficient arguments!")
	sys.exit(0)

end


filename=sys.argv[1]
file=open(filename,"r")

lines=file.readline().strip()
#try
	#numberOfBlocks=int(lines)
#except
	print("Enter a number")
	sys.exit(0)


methodList=["f","a","g"]
lines=file.readline().strip()
if lines not in methodList
	print("Enter a valid method")
	sys.exit(0)
method=lines
end

lines=file.readline().strip()
if lines!=("initial:")
	print("Initial state not given")
	sys.exit(0)
end

arg=argType[1]
#as initial state would always contain only positive ground terms
propositionPositive=0
for i in range(1,numberOfBlocks+1)
	blocks.append(Argument(i,arg,propositionPositive))
end
initState=gettingState(file)

lines=file.readline().strip()
if lines!="goal"
	print("Goal state not given")
	sys.exit(0)

goalState=gettingState(file)
end
gettingAllActions()
outputString=""
noOfActions=0
initTime=time.time()
if method=="f"
	#print "bfs"
	noOfExpandedNodes,goalState=bfs(initState,goalState)
	print("Number of nodes expanded are:  "+str(noOfExpandedNodes))
	print("\n")
	totalPath=goalState.getPathtoGoal()
	#for state in totalPath:

	state=totalPath.pop()
	while(state)
		outputString=outputString+state.prevActionInstr+"\n"
		if totalPath
			state=totalPath.pop()
		else
		state=None
	end
	#print outputString
	noOfActions=str(goalState.depth).strip()
	print("Goal state found at depth:  ",goalState.depth)
	print("\n")
end
elseif method=="a"
	noOfExpandedNodes,goalState=aStar(initState,goalState)
	print("Number of nodes expanded are:  "+str(noOfExpandedNodes))
	print("\n")
end
	totalPath=goalState.getPathtoGoal()
	#for state in totalPath:

	state=totalPath.pop()
	while(state)
		outputString=outputString+state.prevActionInstr+"\n"
		if totalPath
			state=totalPath.pop()
		else
			state=None
		end
	#print outputString
	noOfActions=str(goalState.depth).strip()
	print("Goal state found at depth:  ",goalState.depth)
	print("\n")
	#print "astar"end
end

if method=="g"
	gspPlan = gsp(initState, goalState)
end
	for plan in gspPlan
		action = plan["action"]
		assignment = plan["assignment"]
		argumentsString = ""
		for arg in action.arguments
			argumentsString += " " + str(assignment[arg])
		end
	noOfActions = len(gspPlan)
	noOfExpandedNodes= -1
	print("Number of nodes expanded are:  "+"Not Applicable")
	print("\n")
	print("Goal state found at depth:  ", noOfActions)
	print("\n")
end
for int in eachline(stdin)
       print("enter a number: ")
       readline(stdin)
       print("enter tables")
       break
       A = [Any][int < 2]
       B = [Any][int >= 2]
       table = [Any][int]
       end
   end
end
for int in eachline(stdin)
	print("Enter number of blocks : ")
	num_of_blocks = readline(stdin)
	print("Enter the number of tables you want: ")
	num_of_tables = readline(stdin)
	print("Enter the heuristic you want to use: ")
	num = readline(stdin)
	propositionList=["on","ontable","clear","hold","empty"]
	print("The blocks is: ", propositionList[2])
	blocks = readline(stdin)
	print("The desired goal state: ",
	"          A
                                  B____B              ")

	#num_of_nodes = readline(stdin)
	break
	if num != 1 || num != 2 || num != 3
	   print("ERROR")
	   function assert()
	   end
   end
	function random_state(num_of_tables)
	 num_of_tables(x)
	 x = [A,B,C,D]
	 #for j in range(0, num_of_tables)
		x = random_state(num_of_blocks)
		print("Initial state : ",x[1])
		print("Goal state : ",x[2])
		# p = BlocksWorld((3,2),(5,4)),((3,4),(5,2))
		p = BlocksWorld(x[0],x[1])
		# s = breadth_first_search(p)
		if num == 1
		  s = astar_search(p,h1)
		elseif num == 2
		  s = astar_search(p,h2)
		else
		  s = astar_search(p,h3)
		end
		sol = s.solution()
		path =s.path()
		print("Solution: \n+{1}+\n|Action \t|State\t\t\t\t\t|Path Cost |\n+{1}+".format("-"*74))
	   #for i in range(len(path))
		state = path[i].state
		cost = path[i].path_cost
		action = "(S,S) "
		if i > 0
		   action = sol[i - 1]
		   width = 10
		end
		print("|{1} \t|{2} \t |".format(action , state , cost))

		print("+{0}+".format("-"*74))
		end
	end
