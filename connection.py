__author__ = "Connor George, Dana Cavanagh"
__maintainer__ = "Connor George, Dana Cavanagh"
__credits__ = "Ken Whitener"
__email__ = "TBD"

'''
This file is a connector that uses mysql.connector to connect back to the cookBooked
database. It includes functions that allows access, addition to and deletion of data.
Follows standard ACID transaction management.
'''

from mysql.connector import connect, Error

USER     = 'root'
PASSWORD = 'Animesucks69*'
DATABASE = 'cookBooked'
HOST     = 'localhost'

############################
### CONNECTION FUNCTIONS ###
############################

def getConnection(): 
	'''
    params: None.
    returns: None. \n
    function that creates a connection for user to database.
    will throw exception if there is an issue connecting
    to the database.
    '''
	try:
		return connect(
							user	 = USER,
							password = PASSWORD,
							database = DATABASE,
							host  	 = HOST	
						)
	except Error as err:
		print(f"There was a problem connecting: {err}")
		return None


############################
##### 'GET' FUNCTIONS ######
############################

### GET GENERAL INFORMATION:

def getAllTypes():
	'''
    Params: None.
    Returns: list of ints. \n
    returns a list of all type IDs existing in the database.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = ()
	typeList = []
	cur.callproc('getAllTypes', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for type in results:
		typeList.append(type[0])
	cur.close()
	return typeList


def getTypeName(typeID: int):
	'''
    params: int (typeID).
    returns: string (type name) \n
    Given the ID of a type, returns the corresponding
    type name in database.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = (typeID,)
	cur.callproc( "getTypeName", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getAllCultures():
	'''
    Params: None.
    Returns: list of ints. \n
    returns a list of all culture IDs existing in the database.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = ()
	cultureList = []
	cur.callproc('getAllCultures', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for culture in results:
		cultureList.append(culture[0])
	cur.close()
	return cultureList



def getCultureName(ID: int):
	'''
    params: int (cultureID).
    returns: string (culture name) \n
    Given the ID of a culture, returns the corresponding
    culture name in database.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = (ID,)
	cur.callproc( "getCultureName", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getAllingredients():
	'''
    Params: None.
    Returns: list of ints. \n
    returns a list of all Ingredient IDs existing in the database.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = ()
	ingredientList = []
	cur.callproc('getAllIngredients', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for ingredient in results:
		ingredientList.append(ingredient[0])
	cur.close()
	return ingredientList



def getIngredientName(ingredientID: int):
	'''
    params: int (ingredientID).
    returns: string (ingredient name) \n
    Given the ID of an ingredient, returns the corresponding
    ingredient name in database.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = (ingredientID,)
	cur.callproc( "getIngredientName", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getIngredientsInType(typeId:int):
	'''
	params: int (typeID)
	returns: list of int (list of ingredientIDs) \n
	this function returns a list of all ingredients associated with
	a food type.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (typeId,)
	ingredientList = []
	cur.callproc('getIngredientsInType', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for ingredient in results:
		ingredientList.append(ingredient[0])
	cur.close()
	return ingredientList

def getAllRecipes():
	'''
	params: None
	returns: List of Integers (list of recipeIDs) \n
	this function will return a list of all of the recipeIDs
	currently in the database.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = ()
	ingredientList = []
	cur.callproc('getAllRecipes', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for ingredient in results:
		ingredientList.append(ingredient[0])
	cur.close()
	return ingredientList



### GET USER INFORMATION:

def getFavorites(userID: int):
	'''
    Params: int (userID).
    Return: list of ints (recipeIDs). \n
    returns a list of all recipes a user has favorited, in 
    the form of a list of recipeIDs.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (userID,)
	recipeList = []
	cur.callproc('getUserFavorites', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList


def getDislikes(userID: int):
	'''
    Params: int (userID).
    Return: list of ints (recipeIDs). \n
    returns a list of all recipes a user has disliked, in 
    the form of a list of recipeIDs.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (userID,)
	recipeList = []
	cur.callproc('getUserDislikes', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList


def getRestrictedIngredients(userID: int):
	'''
	params: int (userID).
	returns: list of ints (ingredientIDs). \n
	function returns a list of ingredientIDs that a user cannot
	have because they have restricted a type of food that these
	ingredients are a part of.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (userID,)
	ingredientList = []
	cur.callproc('getRestrictedIngredients', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for ingredient in results:
		ingredientList.append(ingredient[0])
	cur.close()
	return ingredientList


#### FIXME: SECURITY UPDATE FOR PASSWORD
def getUserID(email: str , password: str): 
	'''
	params: string (email), string (password)
	returns: int (userID) \n
	function returns the UserID to corresponding user email and password'''
	con		= getConnection()
	cur		= con.cursor()
	args = (email, password)
	cur.callproc( "getUserID", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getUserName(userID: int):
	'''
	params: int (userID)
	returns: string (user name in format "first last") \n
	this function returns a user's first and last name as one string
	separated by a space, given the user's ID number.'''
	usernameReturned = None
	con		= getConnection()
	cur		= con.cursor()
	args = (userID, usernameReturned)
	out = cur.callproc('getUserName', args)
	cur.close()
	return out[1]



### GET RECIPE INFORMATION:

def getRecipeName(recipeID: int):
	'''
	params: int (recipeID)
	returns: string (recipe name) \n
	given the recipeID, this function returns the title/name of the given recipe'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getTitle", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getRecipeSpice(recipeID: int):
	'''
	params: int (recipeID)
	returns: int (recipe spice level) \n
	given the recipe ID, this functions returns the spice level of a recipe. Which 
	will always be an integer between 0 and 5 inclusive. '''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getSpice", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getRecipeTime(recipeID: int):
	'''
	params: int (recipeID)
	returns: int (recipe time in minutes) \n
	given the recipeID, this function returns the time in minutes a recipe is expected to take 
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getTime", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getRecipeAuthor(recipeID: int):
	'''
	params: int (recipeID)
	returns: str (Author Name) \n
	given a recipeID, this function returns the first and last name
	of the author in one string.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getAuthor", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getRecipeAuthorID(recipeID:int): 
	'''
	params: int (recipeID)
	returns: int (AuthorID) \n
	given a recipeID, this function returns the author's ID.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getAuthorID", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]

def getRecipeIngredients(recipeID:int):
	'''
	params: int (recipeID)
	returns: list of strings (ingredient list) \n
	given the ID number of a recipe, this function returns a list
	of strings representing the name and quantity of each ingredient
	in the recipe.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	ingredientList = []
	cur.callproc('getIngredients', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for ingredient in results:
		ingredientList.append(ingredient[0])
	cur.close()
	return ingredientList


def getRecipeIngredientsID(recipeID:int):
	'''
	params: int (recipeID)
	returns: list of ints (ingredient list) \n
	given the ID number of a recipe, this function returns a list
	of ingredient IDs which represent the ingredients included in the recipe.
	This function does not return information relating to ingredient quantity.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	ingredientList = []
	cur.callproc('getIngredientsID', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for ingredient in results:
		ingredientList.append(ingredient[0])
	cur.close()
	return ingredientList


def getRecipeDescription(recipeID:int):
	'''
	params: int (recipeID)
	returns: string (recipe description) \n
	given a recipeID, this function returns the recipe
	description as a string.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getDescription", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]

def getRecipeCulture(recipeID):
	'''
	params: int (recipeID)
	returns: str (culture name) \n
	given a recipe's ID, this function will return the name of 
	the associated culture (if a recipe has one)
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getCulture", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results


def getRecipeCultureID(recipeID: int):
	'''
	params: int (recipeID)
	returns: int (cultureID) \n
	given a recipe's ID, this function will return ID of the culture associated with it.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getCultureID", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


def getRecipeInstructions(recipeID: int): 
	'''
	params: int (recipeID)
	returns: str (recipe instructions) \n
	given a recipe ID, this function returns the instruction for
	preparing the recipe as one string.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getInstructions", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


############################
##### SEARCH FUNCTIONS #####
############################

def recipesWithSpiceLevel(spiceLevel: int):
	'''
    params: int (spiceLevel).
    returns: list of ints (recipeIDs). \n
    returns a list of recipeIDs corresponding to recipes that
    have the same spice level as the number passed as an arg.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = (spiceLevel,)
	recipeList = []
	cur.callproc('hasSpiceLvL', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList


def recipesWithCulture(culture: int):
	'''
    params: int (cultureID).
    returns: list of ints (recipeIDs). \n
    returns a list of recipeIDs corresponding to recipes that
    have the same associated cultureID as the one passed.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = (culture,)
	recipeList = []
	cur.callproc('hasCulture', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList


def recipesWithAuthor(AuthorID: int):
	'''
    params: int (authorID).
    returns: list of ints (recipeIDs). \n
    returns a list of recipeIDs corresponding to recipes that
    have the same associated authorID as the one passed.
    '''
	con		= getConnection()
	cur		= con.cursor()
	args = (AuthorID,)
	recipeList = []
	cur.callproc('writtenBy', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList

def getRecipesWithoutIngredient(ingrID: int):
	'''
	params: int (ingrID).
	returns: list of ints (recipeList) \n
	returns a list of recipe IDs of recipes that do NOT include the ingredient
	passed as an argument.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (ingrID,)
	recipeList = []
	cur.callproc('doesNotHaveIngredient', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList

def getRecipesWithIngredient(ingrID: int):
	'''
	params: int (ingrID).
	returns: list of ints (recipeList) \n
	returns a list of recipe IDs of recipes that DO include the ingredient
	passed as an argument.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (ingrID,)
	recipeList = []
	cur.callproc('hasIngredient', args)
	for result in cur.stored_results():
		results=result.fetchall()
	for recipe in results:
		recipeList.append(recipe[0])
	cur.close()
	return recipeList


def searchRecipe(typeIdVarLIST: list, spiceLvlVar:int, timeVar:int, authorIdVar:int, cultureIdVar:int, ingreRestrictionVarLIST:list, ingreInclusionVarLIST:list):
	'''
	params: list, int, int ,int , int, list, list
	returns: list (list of recipes)\n
	Primary search method for retreiving recipes from database. In the event of not filling out one of
	the criteria, pass an empty list or None. This function returns a list of recipe IDs fitting the search criteria.
	This recipe DOES NOT account for user ingredient/type restrictions in the database, so make sure to pass them as an argument.
	'''
	listOfLists = []
	length = max(len(ingreRestrictionVarLIST), len(ingreInclusionVarLIST), len(typeIdVarLIST))
	con		= getConnection()
	cur		= con.cursor()
	if length == 0:
		length = 1
	for num in range(length):
		restriction = None
		inclusion   = None
		type = None
		if num < len(ingreRestrictionVarLIST):
			restriction = ingreRestrictionVarLIST[num]
		if num < len(ingreInclusionVarLIST):
			inclusion = ingreInclusionVarLIST[num]
		if num < len(typeIdVarLIST):
			type = typeIdVarLIST[num]
	
		args = (type, spiceLvlVar, timeVar, authorIdVar, cultureIdVar, restriction, inclusion)
		recipeList = []
		cur.callproc('searchForRecipe', args)
		for result in cur.stored_results():
			results = result.fetchall()
			for recipe in results:
				recipeList.append(recipe[0])
		listOfLists.append(recipeList)
	if len(listOfLists) > 1:
		allRecipes = crossCompareINCLUSIVE(listOfLists)
		return allRecipes
	else:
		return listOfLists[0]



###################################
##### TRANSACTIONAL FUNCTIONS #####
###################################

# FIXME -- MAKE SURE EMAIL IS UNIQUE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
def createUserSQL(first: str, last: str, email: str,phone: str,date: str,password: str):
	'''
	params: string (firstName), string (lastName), string (email), string (phoneNumber), string (date), string (password). \n
	returns: None \n
	Attempts to create new user. Throws an exception and rolls back if any part of the transaction fails. 
	'''
	try:
		con		= getConnection()
		cur		= con.cursor()
		args = (first,last,email,phone,date,password)
		cur.callproc('AddUser', args)
		cur.execute("COMMIT;")
		cur.close()
	except Error as error:
		print(f"Database update failed. Rolling Back. \n *** Failure due to: *** \n {error}")
		cur.execute("ROLLBACK;")
	return

### FIXME FIND A WAY TO VALIDATE DATA BEFORE MAKING CHANGES TO DATABASE
def UpdateUserIngredientRestriction(userID: int, ingredientID: int, delete:bool):
	'''
	params: int (userID), int (ingredientID).
	returns: None. \n
	accepts a userID and an ingredientID and adds the ingredient into user's restricted ingredients.'''
	try:
		con		= getConnection()
		cur		= con.cursor()
		args = (userID, ingredientID)
		if delete == False:
			cur.callproc('AddUserIngredientRestriction', args)
			cur.execute("COMMIT;")
		elif delete == True:
			cur.callproc('DeleteUserIngredientRestriction', args)
			cur.execute("COMMIT;")
	except Error as error:
		print(f"uh oh, something went wrong. {error}. database rollback. updateUserIngredientRestriction()")
		cur.execute("ROLLBACK;")
	return


def UpdateUserTypeRestriction(userID: int, typeID: int, delete: bool):
	'''
	params: int (userID), int (typeID)
	returns: None. \n
	Adds a new user type restriction.
	throws exception and rolls back if any part of transaction fails.'''
	try:
		con		= getConnection()
		cur		= con.cursor()
		if delete == False:
			args = (userID, typeID)
			cur.callproc('AddUserTypeRestriction', args)
			cur.execute("COMMIT;")
		elif delete == True:
			args = (userID, typeID)
			cur.callproc('DeleteUserTypeRestriction', args)
			cur.execute("COMMIT;")
	except Error as error:
		print(f"uh oh, something went wrong. {error}. database rollback. updateUserTypeRestriction()")
		cur.execute("ROLLBACK;")
	return


def UpdateFavorite(UserID: int, RecipeID:int, reasoning:str, delete:bool):
	'''
	params: int (UserID), int (RecipeID), str (reasoning).
	returns: None. \n
	adds a recipe to a user's favorited recipe list.  if the fourth parameter is true, it deletes. 
	if the fourth parameter is false it adds. throws an exception and rollsback
	if any part of transaction fails. '''
	try:
		con		= getConnection()
		cur		= con.cursor()
		if delete == False:
			args = (UserID, RecipeID, reasoning)
			cur.callproc('AddFavorite', args)
			cur.execute("COMMIT;")
		elif delete == True:
			args = (UserID, RecipeID)
			cur.callproc('DeleteFavorite', args)
			cur.execute("COMMIT;")
	except Error as error:
		print(f"uh oh, something went wrong:\n {error}.\n database rollback. UpdateFavorite()")
		cur.execute("ROLLBACK;")
	return


def UpdateDislike(UserID: int, RecipeID: int, reasoning: str, delete: bool):
	'''
	params: int (UserID), int (RecipeID), str (reasoning), delete (bool).
	returns: None. \n
	adds or removes a recipe to a user's disliked recipe list. if the fourth parameter is true, it deletes. 
	if the fourth parameter is false it adds. throws an exception and rollsback
	if any part of transaction fails. '''
	try:
		con		= getConnection()
		cur		= con.cursor()
		if delete == False:
			args = (UserID, RecipeID, reasoning)
			cur.callproc('AddDislike', args)
			cur.execute("COMMIT;")
		if delete == True:
			args = (UserID, RecipeID)
			cur.callproc('DeleteDislike', args)
			cur.execute("COMMIT;")
	except Error as error:
		print("uh oh, something went wrong. database rollback. UpdateDislike()")
		cur.execute("ROLLBACK;")
	return





############################################
### SECURITY (NOT YET IMPLEMENTED FULLY) ###
############################################

'''returns a boolean value of whether or not a login is valid.
it is valid if there is a user with that email and password match.
'''
def verifyLogin(email: str, password: str):
	con		= getConnection()
	cur		= con.cursor()
	args = (email, password)
	out = cur.callproc('getUserID', args)
	for result in cur.stored_results():
		results = result.fetchall()
	if len(results) == 0:
		return False
	if isinstance(results[0][0], int):
		return True
	cur.close()
	return False

### FIXME: most likely just delete this, but we'll store it here for now.
def getUserPassword(userId: int):
	con		= getConnection()
	cur		= con.cursor()
	args = (userId,)
	cur.callproc( "getPassword", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results[0][0]


#############################
### MISCELLANEOUS HELPERS ###
#############################

def checkEmailUnique(email: str):
	'''
	params: str (email)
	returns: None \n
	Helper function that returns true if the passed email is in the database, 
	and false otherwise.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (email,)
	cur.callproc( "getUserIDWithEmail", args )
	results = cur.stored_results()
	for result in results:
		res = result.fetchall()
	if (len(res) < 1):
		return True
	cur.close()
	return False

def validateRecipeID(recipeID: int):
	'''
	params: int (recipeID).
	returns: None. \n
	checks if a recipeID exists in the database. Returns true if it exists, 
	and false otherwise.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = (recipeID,)
	cur.callproc( "getTitle", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	if len(results) >= 1:
		return True
	return False

## FIXME
def countRecipes():
	'''
	params: None
	returns int (number of recipes) \n
	this returns the number of recipes currently in the database.
	'''
	con		= getConnection()
	cur		= con.cursor()
	args = ()
	cur.callproc( "countRecipes", args )
	for result in cur.stored_results():
		results = result.fetchall()
	cur.close()
	return results


def crossCompareINCLUSIVE(ListOfLists: list):
	'''
	params: list of lists
	returns: list
	Helper function that cross compares lists of data. returns a list
	with only the data that all lists had in common.'''
	newList = __crossCompareListsINCLUSIVE(ListOfLists[0], ListOfLists[1])
	for index, val in enumerate(ListOfLists):
		if index == len(ListOfLists)-1:
			newList2 = __crossCompareListsINCLUSIVE(newList, ListOfLists[index])
			return newList2
		else:
			newList = __crossCompareListsINCLUSIVE(newList, ListOfLists[index])


def __crossCompareListsINCLUSIVE(List1: list, List2: list):
	'''
	params: list, list.
	returns: list \n
	helper function for crossCompareINCLUSIVE(), this function cross compares two
	lists and returns only the data they have in common (in the form of a list)
	'''
	ListNEW = []
	for item in List1:
		if (item in List2):
			ListNEW.append(item)
	return ListNEW
