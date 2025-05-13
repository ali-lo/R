# inspired by the Buzzfeed What kind of potato are you? quiz that I remember seeing years ago
# link to original Buzzfeed quiz https://www.buzzfeed.com/gracegrace24/what-kind-of-potato-are-you-2y2f4

# define functions (on the module level)
# def ask_for_name(), user's name function
def ask_for_name():
    name = input("Hello! What's you're name? ") # input string
    return name 

# general multiple choice function (x2)
def ask_multiple_choice_question(question, num_options): # the question argument is a string that is the question prompt, including all of the option and the n argument is an integer indicating the number of options
    answer = int(input(question))
    if 1<= answer <= num_options: # only accept an answer that is within the acceptabe range
        return answer
    else:
        print("There is a problem with your answer! Please try the question again!")
        second_answer = ask_multiple_choice_question(question, num_options) # recursion
        return second_answer

# free response question function
def ask_favorite_season():
    fav_season = input("Free response: What is your favorite season? (spring, summer, winter, or fall) \n > ")
    lower_fav_season = fav_season.lower() # lowercase string processing, need () when calling a string
    if lower_fav_season.startswith("win"): # use startswith string method to try handle typos, abbreviations, and misspellings 
        return 1
    elif lower_fav_season.startswith("fa"):
        return 2
    elif lower_fav_season.startswith("spr"):
        return 3
    elif lower_fav_season.startswith("sum"):
        return 4
    else:
        print("Hmmm... there seems to be a problem with your answer. Please try the question again!")
        second_fav_season = ask_favorite_season() # recursion
        return second_fav_season

# branching question function
def ask_drink_pref(): 
    result_drink_pref = ask_multiple_choice_question("Do you prefer hot or cold drinks? \n 1.hot \n 2.cold \n > ", 2)
    if result_drink_pref == 1:
        ask_potato_sides = ask_multiple_choice_question("Which do you prefer to eat with potatoes? \n 1.steak \n 2.grilled eggplant \n > ", 2)
        if ask_potato_sides == 1:
            return 1
        elif ask_potato_sides == 2:
            return 2
    elif result_drink_pref == 2:
        ask_food_sourcing = ask_multiple_choice_question("How do you prefer to get your food? \n 1.grocery store \n 2.gardening \n > ", 2)
        if ask_food_sourcing == 1:
            return 1
        elif ask_food_sourcing == 2:
            return 2

# reporting results function
def report_results(score, name): # score input is an integer and name input is a string
    print("Results for:", name) # uses results from earlier name function to personalize results 
    if score <= 10:
        print("You are mashed potatoes!")
    elif score <= 16: # specifying ranges, already removed the <= 10 scores
        print("You are a potato chip!")
    elif score < 21:
        print("You are a sweet potato!")
    else:
        print("You are a garden potato!")

# define take_quiz() function
def take_quiz():
    name = ask_for_name()
    print(str("Welcome " + name + "! " + "Let's find out what type of potato you are!")) # welcome statement
    # specify functions for quiz questions
    result_thanksgiving_food = ask_multiple_choice_question("Which Thanksgiving food do you prefer? \n 1.stuffing \n 2.turkey \n 3.cranberry sauce \n 4.green beans \n > ", 4)
    result_describe_you = ask_multiple_choice_question("How would someone describe you? \n 1.nice \n 2.main-character energy \n 3.sweet \n 4.chaotic \n > ", 4)
    result_fav_season = ask_favorite_season()
    result_potato_dish = ask_multiple_choice_question("What is your favorite potato dish? \n 1.mashed potatoes \n 2.fries \n 3.potato latkes \n 4.pierogies \n > ", 4)
    result_food_drinks = ask_drink_pref()
    result_fries = ask_multiple_choice_question("Who has the best fries? \n 1.Wendy's \n 2.McDonalds \n 3.Chick-fil-a \n 4.I don't eat fries \n > ", 4)
    
    # sum all scores after the scoring method has been applied 
    total_score = result_thanksgiving_food + result_describe_you + result_fav_season + result_potato_dish + result_food_drinks + result_fries
    
    # determine and return result of quiz
    results = report_results(total_score, name)
    return results


# call function after they are defined 
if __name__ == '__main__':
    take_quiz()