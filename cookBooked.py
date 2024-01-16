import connection as c
from datetime import date

#########################
### GLOBAL VARIABLES ####
LOGIN = False
USERID = None
GUEST = False


###################################
########### FUNCTIONS #############
###################################


############################
##### `SHOW` FUNCTIONS #####

def ShowFavorites():
    '''
    @params: None.
    @returns: None.
    prints current user's favorited recipes to commandLine
    '''
    favoriteRecipes = c.getFavorites(USERID)
    print("=======================================================")
    print("============== YOUR FAVORITED RECIPES: ================")
    for favorite in favoriteRecipes:
        name = c.getRecipeName(favorite)
        print(f"[{favorite}]: {name}")
    print()

def ShowDislikes():
    '''
    @params: None.
    @returns: None.
    prints current user's disliked recipes to commandLine
    '''
    dislikedRecipes = c.getDislikes(USERID)
    print("=======================================================")
    print("=============== YOUR DISLIKED RECIPES: ================")
    for dislike in dislikedRecipes:
        name = c.getRecipeName(dislike)
        print(f"[{dislike}]: {name}")
    print()
    print()

def ShowRecipe(recipeID):
    '''
    @params: recipeID (int): the id of a recipe in the database.
    @returns: None.
    prints stored information about a recipe to the command line
    '''
    title = c.getRecipeName(recipeID)
    author = c.getRecipeAuthor(recipeID)
    spice = c.getRecipeSpice(recipeID)
    culture = c.getRecipeCulture(recipeID)
    ingredients = c.getRecipeIngredients(recipeID)
    description = c.getRecipeDescription(recipeID)
    instructions = c.getRecipeInstructions(recipeID)
    time = c.getRecipeTime(recipeID)
    print()
    print("=======================================================")
    print("=== +++++++++++++++++++++++++++++++++++++++++++++++ ===")
    print(title)
    print(f"written by: {author}")
    print(f"cook time: {time//60}hr {time%60}mins")
    print(f"spice level: {spice}")
    if (len(culture) >= 1):
        print(f"cultural origins: {culture}")
    print(f"")
    print(f"Description: {description}")
    print()
    print(f"++++ INGREDIENTS ++++")
    for index, ingredient in enumerate(ingredients):
        print(f"{index}) {ingredient}")
    print()
    print(f"++++ INSTRUCTIONS: ++++")
    print(instructions)


############################
#### `CHOOSE` FUNCTIONS ####

def ChooseRecipesIvePublished():
    '''
    @param: NONE
    @returns: None. Displays all recipes published by current User.'''
    myRecipes = c.recipesWithAuthor(USERID)
    print("=======================================================")
    print("=============== MY PUBLISHED RECIPES ==================")
    for index, recipe in enumerate(myRecipes):
        print(f"{index+1}) {c.getRecipeName(recipe)}")
    print("type anything to return home! :)")
    typed = input()
    return

def ChooseFavorites():
    '''
    @params: None
    @returns: None. Displays all favorited recipes by user.
    Then accepts choice through consol input to view recipe or return.'''
    ShowFavorites()
    print("What would you like to do now?")
    print("1) View One Of My Favorite Recipes")
    print("2) Return To Previous")
    print("Enter the number of your choice: ")
    choice = input()
    while not choice.isnumeric() or int(choice) not in [1,2]:
        print("I'm sorry, please enter /just/ the number of one of the options above.")
        choice = input()
    choice = int(choice)
    if choice == 1:
        print("Great! Please enter the number of the recipe you'd like to view: ")
        print("(Notice on your favorites list each recipe has a number to it's left)")
        recipeID = input()
        validated = c.validateRecipeID(recipeID)
        while not validated:
            print("I'm sorry, that's not a valid recipe number. Please retry.")
            recipeID = input()
            validated = c.validateRecipeID(recipeID)
        ChooseViewRecipe(recipeID)
        return
    else:
        return

def ChooseDislikes():
    '''
    @params: None
    @returns: None. Displays all disliked recipes by user.
    Then accepts choice through consol input to view recipe or return.'''
    ShowDislikes()
    print("What would you like to do now?")
    print("1) View One Of My Disliked Recipes")
    print("2) Return To Previous")
    print("Enter the number of your choice: ")
    choice = input()
    while not choice.isnumeric() or int(choice) not in [1,2]:
        print("I'm sorry, please enter /just/ the number of one of the options above.")
        choice = input()
    choice = int(choice)
    if choice == 1:
        print("Great! Please enter the number of the recipe you'd like to view: ")
        print("(Notice on your Disliked list each recipe has a number to it's left)")
        recipeID = input()
        validated = c.validateRecipeID(recipeID)
        while not validated:
            print("I'm sorry, that's not a valid recipe number. Please retry.")
            recipeID = input()
            validated = c.validateRecipeID(recipeID)
        ChooseViewRecipe(recipeID)
        return
    else:
        return
        
def ChooseSearch():
    '''
    @params: None
    @returns: None. Prompts user through console input for information
    to search database through recipe. redirects users to ChooseViewRecipe(int recipeID) or returns'''
    ingredientINCLUDE = []
    ingredientEXCLUDE = []
    allIngredients = []
    if GUEST != True:
        list1 = c.getIngredientCANhave(USERID)
        for item in list1:
            allIngredients.append(item)
    elif GUEST == True:
        list1 = c.getAllingredients()
        for item in list1:
            allIngredients.append(item)
    spiceLevel = None
    author = None
    Culture = None
    print("In order to search for a recipe I'm going to have to collect some information...")
    print("Are there any specific ingredients you want INCLUDED in the recipe? (Y/N)")
    answer = input()
    while not answer in ["Y", "N"]:
        print("I'm sorry, but thats not a valid answer. please enter Y or N")
        answer = input()
    if answer == "Y":
        print("Okay, which of the following ingredients would you like to INCLUDE?")
        print("enter the number next to the ingredient. one at a time. enter DONE when you are complete.")
        for ingredient in allIngredients:
            print(f"{ingredient}] {c.getIngredientName(ingredient)}")
        ingr = input()
        while not ingr == "DONE":
            while not ingr.isnumeric() or int(ingr) not in allIngredients:
                print("sorry, invalid input. Please choose an ingredient and enter the Number on the left of it.")
                print ("or enter DONE if you are done adding ingredients")
                ingr = input()
            ingredientINCLUDE.append(int(ingr))
            allIngredients.remove(int(ingr))
            ingr = input()

    print("Okay, now are there any ingredients you do NOT want included? (Y/N)")
    answer = input()
    while not answer in ["Y", "N"]:
        print("I'm sorry, but thats not a valid answer. please enter Y or N")
        answer = input()
    if answer == "Y":
        print("enter the number next to the ingredient. one at a time. enter DONE when you are complete.")
        for ingredient in allIngredients:
            print(f"{ingredient}] {c.getIngredientName(ingredient)}")
        ingr = input()
        while not ingr == "DONE":
            while not ingr.isnumeric() or int(ingr) not in allIngredients:
                print("sorry, invalid input. Please choose an ingredient and enter the Number on the left of it.")
                print ("or enter DONE if you are done excluding ingredients")
                ingr = input()
            ingredientEXCLUDE.append(int(ingr))
            ingr = input()
        
    print("What level would you like the spice to be? enter a number 0-5, or DONE if you don't have a preference.")
    ingr = input()
    if ingr != "DONE":
        while not ingr.isnumeric() or int(ingr) not in [0,1,2,3,4,5]:
            print("sorry, invalid input. Please choose a number between 0 and 5.")
            print ("or enter DONE if you dont have a spice preference")
            ingr = input()
        spiceLevel = int(ingr)

    print("Is there a specific culture you'd like the recipe to be a part of? (Y/N)")
    answer = input()
    while not answer in ["Y", "N"]:
        print("I'm sorry, but thats not a valid answer. please enter Y or N")
        answer = input()
    if answer == "Y":
        print("Here are the cultural options, please enter the number of the culture you'd likd to include in your search criteria. or enter DONE")
        cultures = c.getAllCultures()
        for culture in cultures:
            print(f"{culture}] {c.getCultureName(culture)}")
        ingr = input()
        if not ingr == "DONE":
            while not ingr.isnumeric() or int(ingr) not in allIngredients:
                print("sorry, invalid input. Please choose an ingredient and enter the Number on the left of it.")
                print ("or enter DONE if you are done excluding ingredients")
                ingr = input()
            Culture = ingr
    recipesLIST = recipeSearch(ingredientEXCLUDE, ingredientINCLUDE, spiceLevel, Culture, author) #FIXME
    print()
    print()
    indexList = []
    if len(recipesLIST) == 0:
        print("i'm sorry, but no recipes matched your criteria. Returning you home...")
        return
    print("Here are the recipes returned: ")
    for recipe in recipesLIST:
        recipeObj = recipe
        if isinstance(recipe, list):
            if isinstance(recipe[0], list):
                recipeObj = recipe[0]
                if isinstance(recipeObj[0], list):
                    for obj in recipeObj[0]:
                        print(f"{obj}] {c.getRecipeName(obj)}")
                        indexList.append(obj)
                else:
                    for obj in recipeObj:
                        print(f"{obj}] {c.getRecipeName(obj)}")
                        indexList.append(obj)
            else:
                for obj in recipe:
                    print(f"{obj}] {c.getRecipeName(obj)}")
                    indexList.append(obj)
        else:
            print(f"{recipe}] {c.getRecipeName(recipe)}")
            indexList.append(recipe)

    print()
    print("Above are the returned results from your search.")
    print("What would you like to do now?")
    print("1) view recipe")
    print("2) return")
    answer = input()
    while not answer.isnumeric() or int(answer) not in [1,2]:
        print("invalid answer. Please try again.")
        answer = input()
    answer = int(answer)
    while answer != 2:
        print("Which recipe would you like to view? Enter the number next to your chosen recipe.")
        recipeID = input()
        while (recipeID.isnumeric() == False) or (int(recipeID) not in indexList):
            print("invalid answer. Please try again. Type DONE to return")
            recipeID = input()
        if recipeID == "DONE":
            return
        ChooseViewRecipe(int(recipeID))
        print("What would you like to do now?")
        print("1) view recipe")
        print("2) return")
        answer = input()
        if answer.isnumeric():
            answer = int(answer)

    return

def ChooseViewRecipe(recipeID):
    '''
    @param: (int) recipeID
    @returns: None. Prints to console information about the recipe passed. 
    Queues user via console input to add to favorites, add to dislikes or return to main loop.'''
    ShowRecipe(recipeID)
    print()
    if (GUEST == False):
        print("After viewing this recipe, please enter your choice of doing the following actions: ")
        print("1) add recipe to favorites")
        print("2) add recipe to dislikes")
        print("3) return to home")
        choice = input()
        while not choice.isnumeric() or int(choice) not in [1,2,3]:
            print("I'm sorry, please enter /just/ the number of one of the options above.")
            choice = input()
        choice = int(choice)
        if choice == 1:
            print("Any particular reason?")
            reason = input()
            c.UpdateFavorite(USERID, recipeID, reason)
            print("Added to Favorites! Returning Home Now! : )")
            print()
            return
        if choice == 2:
            print("Any particular reason?")
            reason = input()
            c.UpdateDislike(USERID, recipeID, reason)
            print("Added to Dislikes! Returning Home Now!")
            print()
            return
        else:
            return
    if (GUEST == True):
        print("After viewing this recipe, please enter your choice of doing the following actions: ")
        print("1) return to home")
        choice = input()
        while not choice.isnumeric() or int(choice) not in [1]:
            print("I'm sorry, please enter /just/ the number of one of the options above.")
            choice = input()
        choice = int(choice)
        if choice == 1:
            return


############################
###### MISC. FUNCTIONS #####
        
##needs doc
def setupUserRestrictions():
    print("We're now going to ask you some questions about your dietary requirements.")
    print("Do you have any foods you want EXCLUDED from all future recipe searches? (y/n)")
    answer = input()
    while answer not in ["y", "n"]:
        print("invalid answer, please enter y (for yes) or n (for no)")
        answer = input()
    if answer == "n":
        print("Great! You're all set then.")
        return
    print()
    print()
    print("Do you exclude any of the following types of food from your diet?")
    print("These types may be inclusive of other types. For example if you are vegan")
    print("you only need to select animal products and seafood. no need to also select dairy/meat/etc.")
    print("but you may still do that if you'd like.")
    print("NOTE: animal product and meat do not include seafood.")
    print("enter DONE when you are finished selecting items")
    types = c.getAllTypes()
    for type in types:
        name = c.getTypeName(type)
        print(f"[{type}] {name}")
    selection = input()
    while (selection != "DONE"):
        while not selection.isnumeric() or int(selection) not in types:
            print("that was an invalid selection. please try again")
            selection = input()
        c.UpdateUserTypeRestriction(USERID, int(selection))
        print(f"Great! {c.getTypeName(selection)} added to your type restrictions!")
        print("continue selecting or type DONE if you are complete")
        selection = input()
    ### now to set up user specific ingredient restrictions:
    print()
    print("Are there any specific ingredients that you'd like excluded from all future searches? (y/n)")
    while answer not in ["y", "n"]:
        print("invalid answer, please enter y (for yes) or n (for no)")
        answer = input()
    if answer == "n":
        print("Great! You're all set then.")
        return
    print("Here are the other ingredients in the database, enter the number of any ingredient that you'd like excluded. ")
    print("Enter DONE when finished")
    ingredients = c.getIngredientCANhave(USERID)
    print()
    for ingredientIndex in ingredients:
        print(f"[{ingredientIndex}] {c.getIngredientName(ingredientIndex)}")
    selection = input()
    while (selection != "DONE"):
        while not selection.isnumeric() or int(selection) not in types:
            print("that was an invalid selection. please try again")
            selection = input()
        c.UpdateUserTypeRestriction(USERID, int(selection))
        print(f"Great! {c.getTypeName(selection)} added to your ingredient restrictions!")
        print("continue selecting or type DONE if you are complete")
        selection = input()
    print("Great! You're All Set!")
    return
   
##needs doc
def completeRecipe(title, desc, time, spice, date, cal, USERID, instructions, ingredientsToBeAdded, culturesToAdd):
    try:
        con		= c.getConnection()
        cur		= con.cursor()
        args = (title, desc, time, spice, date, cal, USERID, instructions)
        cur.callproc('writeRecipe', args)
        recipeID = c.countRecipes()
        recipeID = getDataAsList(recipeID)
        recipeID = recipeID[0][0]
        for ingredient in ingredientsToBeAdded:
            one = ingredient[0]
            two = ingredient[1]
            three =  ingredient[2]
            four = ingredient[3]
            args = (recipeID, one, two, three, four)
            cur.callproc('addRecipe_Ingredient', args)
        for culture in culturesToAdd:
            args = (recipeID, culture)
            cur.callproc('setCulture', args)
        cur.execute("COMMIT;")
        print("recipe successfully published! returning you home!")
        print()
    except:
        print("An issue occured submitting this recipe. Rolling back data. Please Try Again.")
        cur.execute("ROLLBACK;")
        cur.close()
        return

def recipeSearch(ingredientsToNOTinclude, ingredientsToInclude, SpiceLevel, Culture, Author=None ):
    restrictedIngredients = []
    if GUEST == False:
        restrictedIngredients = c.getRestrictedIngredients(USERID)
    ##handling excluded ingredients
    recipes = []
    for ingredient in ingredientsToNOTinclude: 
        restrictedIngredients.append(ingredient)
    listOfLists = []
    if len(restrictedIngredients) >= 1: 
        for ingredient in restrictedIngredients:
            recipeList = c.getRecipesWithoutIngredient(ingredient)
            listOfLists.append(recipeList)
        recipes = listOfLists
        if len(listOfLists) >= 2:
            recipes = c.crossCompareINCLUSIVE(listOfLists)
    ##handling inlcuded ingredients
    listOfLists2 = []
    recipes2 = []
    if len(ingredientsToInclude) >= 1:
        for ingredient in ingredientsToInclude: 
            recipeList = c.getRecipesWithIngredient(ingredient)
            listOfLists2.append(recipeList) 
        recipes2 = listOfLists2
        if len(listOfLists2) >= 2:
            recipes2 = c.crossCompareINCLUSIVE(listOfLists2)
        
    
    ##handling SpiceLevel
    spiceRecipes = []
    if (SpiceLevel != None):
        spiceRecipes = c.recipesWithSpiceLevel(SpiceLevel)
    
    #Handling culture
    cultureRecipes = []
    if Culture != None:
        cultureRecipes = c.recipesWithCulture(Culture)
    
    #HandlingAuthor
    authorRecipes = []
    if Author != None:
        authorRecipes = c.recipesWithAuthor(Author)

    finalBossList = []
    for recipeList in [recipes, recipes2, spiceRecipes, cultureRecipes, authorRecipes]:
        if len(recipeList) > 0:
            finalBossList.append(recipeList)
    
    if len(finalBossList) >= 2:
        perfectList = c.crossCompareINCLUSIVE(finalBossList)
    elif len(finalBossList) == 0:
        allRecipes = c.getAllRecipes()
        return allRecipes
    else:
        return finalBossList
    return perfectList


############################
##### HELPER FUNCTIONS #####

def getDataAsList(recipesLIST):
    '''
    @params: recipesList (list)
    @returns: list of recipeIDs
    \n temporary work around for data recieved from procedures that is some sort of
    nested list. This function pulls out nested data and returns it as one list.'''
    indexList = []
    for recipe in recipesLIST:
        recipeObj = recipe
        if isinstance(recipe, list):
            if isinstance(recipe[0], list):
                recipeObj = recipe[0]
                if isinstance(recipeObj[0], list):
                    for obj in recipeObj[0]:
                        indexList.append(obj)
                else:
                    for obj in recipeObj:
                        indexList.append(obj)
            else:
                for obj in recipe:
                    indexList.append(obj)
        else:
            indexList.append(recipe)
    return indexList

def validateInput(input:str, canBe:list, shouldBeNumeric:bool):
    '''
    params: str (user's input), list (list of all acceptable inputs), bool (represents if an input should be numeric)
    returns: user's choice validated.'''
    if shouldBeNumeric and input.isnumeric():
        input = int(input)
    elif shouldBeNumeric and not input.isnumeric():
        print(f"I'm sorry. Input should be numeric. Try Again:")
        new = input()
        return validateInput(new, canBe, shouldBeNumeric)
    
    if input not in canBe:
        print(f"I'm sorry. That's invalid input. Try Again:")
        new = input()
        return validateInput(new, canBe, shouldBeNumeric)
    else:
        return input



    
#################
### MAIN LOOP ###
#################


while(True):

    print("===============================================")
    print("============ WELCOME TO COOKBOOKED ============")
    print("===============================================")
    print()
    ########################################################################
    ############################# LOGGING IN ###############################
    print("Would you like to Login? Sign Up? Or Browse As Guest?")
    print("(enter the number of your preferred option below)")
    print("[1] - Login")
    print("[2] - Sign Up")
    print("[3] - Browse As Guest")
    logged = input()
    while (logged.isnumeric() == False):
        print()
        print("There seems to be an error in your input. Please try again.")
        print("Remember to ONLY enter the number of your choice.")
        print("[EX: type '3' (no quotes) if you'd like to Browse As Guest]")
        logged = input()
    logged = int(logged)
    while (logged != 1 and logged != 2 and logged !=3):
        print()
        print("It looks like you entered a number that isn't an option. Please try again.")
        logged = input()
    if (LOGIN == False):
        if (int(logged) == 3):
            GUEST = True
            pass
        if (int(logged) == 2):
            print()
            print("We're Glad You'd Like To Sign Up For CookBooked!")
            print("We'll Just Need To Collect Some Information From You Now: ")
            print("What is your First Name?")
            first = input()
            print("What is you Last/Family Name?: ")
            last = input()
            print("What is your email?")
            email = input()
            emailUnique = c.checkEmailUnique(email)
            while ( not emailUnique):
                print("I'm sorry, it looks like that email is already in use.")
                print("please enter a different one: ")
                email = input()
                emailUnique = c.checkEmailUnique(email)
            print("what is your phone number?")
            phone = input()
            print("what would you like your password to be?")
            password = input()
            c.createUserSQL(first, last, email, phone, date.today(), password)
            USERID = c.getUserID(email, password)
            LOGIN = True
            GUEST = False
            setupUserRestrictions()

        if (int(logged) == 1):
            print("WELCOME BACK!")
            print("What's your email? ")
            email = input()
            print("What's your password? ")
            password = input()
            secure = c.verifyLogin(email,password)
            while (secure != True):
                print("I'm sorry, it seems like you entered the wrong email or password.")
                print("Please enter your email again: ")
                email = input()
                print("Now your password, please: ")
                password = input()
                secure = c.verifyLogin(email,password)
            if secure:
                USERID = c.getUserID(email, password)
                LOGIN  = True
                GUEST  = False


        ##################################################################
        ################ SELECTING WHAT THEY WANT TO DO ##################
        print("Welcome in to CookBooked! Enter the Number of the choice below you'd like to do\n (enter 'DONE' to exit the program)")
        print("1) Search For A Recipe")
        print("2) View My Favorites (not available for guests)")
        print("3) View My Dislikes (not available for guests)")
        print("4) View Recipes I've Published (not available for guests)")
        print("5) Publish A New Recipe (not available for guests)")
        choice = "nothing"
        while (choice != "DONE"):
            choice = input()
            if choice == "DONE":
                quit()
            while not choice.isnumeric() or int(choice) not in [1,2,3,4,5]:
                print("I'm sorry, but that's not a valid input. please enter a number or DONE")
                choice = input()
            choice = int(choice)
            if choice == 1:
                ChooseSearch()
                print()
                print("Welcome in to CookBooked! Enter the Number of the choice below you'd like to do\n (enter 'DONE' to exit the program)")
                print("1) Search For A Recipe")
                print("2) View My Favorites (not available for guests)")
                print("3) View My Dislikes (not available for guests)")
                print("4) View Recipes I've Published (not available for guests)")
                print("5) Publish A New Recipe (not available for guests)")
        
            if choice == 2:
                if GUEST == True:
                    print("Sorry, guests can't do this. Please Choose another option")
                    continue
                ChooseFavorites()
                print()
                print("Welcome in to CookBooked! Enter the Number of the choice below you'd like to do\n (enter 'DONE' to exit the program)")
                print("1) Search For A Recipe")
                print("2) View My Favorites (not available for guests)")
                print("3) View My Dislikes (not available for guests)")
                print("4) View Recipes I've Published (not available for guests)")
                print("5) Publish A New Recipe (not available for guests)")
            
            if choice == 3:
                if GUEST == True:
                    print("Sorry, guests can't do this. Please Choose another option")
                    continue
                ChooseDislikes()
                print()
                print("Welcome in to CookBooked! Enter the Number of the choice below you'd like to do\n (enter 'DONE' to exit the program)")
                print("1) Search For A Recipe")
                print("2) View My Favorites (not available for guests)")
                print("3) View My Dislikes (not available for guests)")
                print("4) View Recipes I've Published (not available for guests)")
                print("5) Publish A New Recipe (not available for guests)")
          
            if choice == 4:
                if GUEST == True:
                    print("Sorry, guests can't do this. Please Choose another option")
                    continue
                ChooseRecipesIvePublished()
                print()
                print("Welcome in to CookBooked! Enter the Number of the choice below you'd like to do\n (enter 'DONE' to exit the program)")
                print("1) Search For A Recipe")
                print("2) View My Favorites (not available for guests)")
                print("3) View My Dislikes (not available for guests)")
                print("4) View Recipes I've Published (not available for guests)")
                print("5) Publish A New Recipe (not available for guests)")
            if choice == 5:
                if GUEST == True:
                    print("Sorry, guests can't do this. Please Choose another option")
                    continue
                if LOGIN == True:
                    date = date.today()
                    addMore = True
                    print("There's some things we need inorder for you to publish a recipe...")
                    while (addMore == True):
                        print("Give it a title: ")
                        title = input()
                        print(f"Are you sure '{title}' is what you want to go with? Y/N")
                        confirm = input()
                        while (confirm != "Y" and confirm != "N"):
                            print("It looks like you entered a value that is not Y or N.")
                            confirm = input()
                        if (confirm == "Y"):
                            addMore = False
                        if (confirm == "N"):
                            addMore = True
                    addMore = True
                    while (addMore == True):
                        print("Give a quick description of your meal: ")
                        desc = input()
                        print(f"Are you sure '{desc}' is what you want to go with? Y/N")
                        confirm = input()
                        while (confirm != "Y" and confirm != "N"):
                            print("It looks like you entered a value that is not Y or N.")
                            confirm = input()
                        if (confirm == "Y"):
                            addMore = False
                        if (confirm == "N"):
                            addMore = True
                    addMore = True
                    while (addMore == True):
                        print("How long (the length in minutes) does it take to make?")
                        time = input()
                        while (time.isnumeric() == False):
                            print("It looks like you entered a value that is not a number, please try again: ")
                            time = input()
                        print(f"Are you sure it will take {time} minutes to completely make the dish? Y/N")
                        confirm = input()
                        while (confirm != "Y" and confirm != "N"):
                            print("It looks like you entered a value that is not Y or N.")
                            confirm = input()
                        if (confirm == "Y"):
                            addMore = False
                        if (confirm == "N"):
                            addMore = True
                    culturesToAdd = []
                    allCultures = c.getAllCultures()
                    addMore = True
                    while (addMore == True):
                        print("Let's see if your recipe matches up with a culture: ")
                        for culture in allCultures:
                            name = c.getCultureName(culture)
                            print(f"{culture}) {name}")
                        print("To add a culture, enter the number associated with it (if you'd like to ignore this question, type -1): ")
                        cultureID = input()
                        if (int(cultureID) == -1):
                            break
                        while (int(cultureID) not in allCultures):
                            print("It looks like you entered a value that is not in the list: ")
                            cultureID = input()
                        name = c.getCultureName(cultureID)
                        print(f"Are you sure your recipe falls under: {name}? Y/N")
                        confirm = input()
                        while (confirm != "Y" and confirm != "N"):
                            print("It looks like you entered a value that is not Y or N.")
                            confirm = input()
                        if (confirm == "N"):
                            addMore = True
                        if (confirm == "Y"):
                            culturesToAdd.append(cultureID)
                            print("Do you want to link your recipe to another culture?(Y/N)")
                            confirm = input()
                            while (confirm != "Y" and confirm != "N"):
                                print("It looks like you entered a value that is not Y or N: ")
                                confirm = input()
                            if (confirm == "Y"):
                                addMore = True
                            if (confirm == "N"):
                                addMore = False
                    addMore = True
                    while (addMore == True):  
                        print("On a scale of 1 - 5 how spicy is your dish? (if you'd like to ignore this question, type -1): ")
                        spice = input()
                        if (int(spice) == -1):
                            pass
                        while int(spice) not in [-1, 1, 2, 3, 4, 5] :
                            print("It looks like you entered a value that is not within the scale, please try again: ")
                            spice = input()
                        if (int(spice) != -1):
                            print(f"Are you sure it lands as a {spice} on the spice scale? Y/N")
                            confirm = input()
                            while (confirm != "Y" and confirm != "N"):
                                print("It looks like you entered a value that is not Y or N.")
                                confirm = input()
                            if (confirm == "Y"):
                                addMore = False
                            if (confirm == "N"):
                                addMore = True
                        addMore = False
                    addMore = True
                    while (addMore == True):
                        print("How many calories are there per serving? (if you'd like to ignore this question, type -1): ")
                        cal = input()
                        try:
                            cal = int(cal)
                        except:
                            while (cal.isnumeric() == False):
                                print("It looks like you entered an unsupported value.")
                                print("Please enter a whole number: ")
                                cal = input()
                        if (int(cal) == -1):
                            cal = None
                        elif (int(cal) != -1):
                            print(f"Are you sure it has {cal} calories per serving? Y/N")
                            confirm = input()
                            while (confirm != "Y" and confirm != "N"):
                                print("It looks like you entered a value that is not Y or N.")
                                confirm = input()
                            if (confirm == "Y"):
                                addMore = False
                            if (confirm == "N"):
                                addMore = True
                        addMore = False
                    print("Okay let's get the ingredients written down. Here's a list of available ingredients: ")
                    allIngredients = c.getALLingredients()
                    addMore = True
                    ingredientsToBeAdded = []
                    while (addMore == True):
                        for ingredient in allIngredients:
                            name = c.getIngredientName(ingredient)
                            print(f"{ingredient}) {name}")
                        print("To add an ingredient, enter the number associated with it: ")
                        ingredID = input()
                        while (int(ingredID) not in allIngredients):
                            print("It looks like you entered a value that is not in the list: ")
                            ingredID = input()
                        name = c.getIngredientName(ingredID)
                        print("What type (not number) of measurement are you using?")
                        measureType = input()
                        print("And how much of that measurement do you need? Please enter as a decimal. (1/3 would be 0.33, 1/2 0.5, etc)")
                        quant = input()
                        print("Are there any notes you'd like to add for this ingredient? (Brand, minced, sliced, etc)")
                        note = input()
                        print(f"Are you sure {quant} {measureType} of {name} with a note of '{note}' is in the recipe?")
                        print("Remember, there can be only one entry per ingredient! Y/N")
                        confirm = input()
                        while (confirm != "Y" and confirm != "N"):
                            print("It looks like you entered a value that is not Y or N.")
                            confirm = input()
                        if (confirm == "N"):
                            addMore = True
                        if (confirm == "Y"):
                            ingredientsToBeAdded.append((int(ingredID), float(quant), measureType, note))
                            print("Do you want to add another ingredient?(Y/N)")
                            confirm = input()
                            while (confirm != "Y" and confirm != "N"):
                                print("It looks like you entered a value that is not Y or N.")
                                print("Do you want to add another ingredient?(Y/N)")
                                confirm = input()
                            if (confirm == "Y"):
                                addMore = True
                            if (confirm == "N"):
                                addMore = False
                    print("With all of that set up, lets write the instructions: ")
                    instructions = ""
                    addMore = True
                    while (addMore == True):
                        print("Write the step: ")
                        step = input()
                        print(f"Are you sure: {step} is in the correct? Y/N")
                        confirm = input()
                        while (confirm != "Y" and confirm != "N"):
                            print("It looks like you entered a value that is not Y or N.")
                            confirm = input()
                        if (confirm == "N"):
                            addMore = True
                        if (confirm == "Y"):
                            instructions = instructions + step + "/n"
                            print("Do you want to add another step?(Y/N)")
                            confirm = input()
                            while (confirm != "Y" and confirm != "N"):
                                print("It looks like you entered a value that is not Y or N.")
                                print("Do you want to add another step?(Y/N)")
                                confirm = input()
                            if (confirm == "Y"):
                                addMore = True
                            if (confirm == "N"):
                                addMore = False
                    completeRecipe(title, desc, time, spice, date, cal, USERID, instructions, ingredientsToBeAdded, culturesToAdd)
                    print()
                    print("Welcome in to CookBooked! Enter the Number of the choice below you'd like to do\n (enter 'DONE' to exit the program)")
                    print("1) Search For A Recipe")
                    print("2) View My Favorites (not available for guests)")
                    print("3) View My Dislikes (not available for guests)")
                    print("4) View Recipes I've Published (not available for guests)")
                    print("5) Publish A New Recipe (not available for guests)")
                            
                    
