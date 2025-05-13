# def parse_search_query(), returns list of tuples
def parse_search_query(string_search_query): # string inputted by the user
    individual_words_list = string_search_query.split(" ") # separate at white spaces 
    token_list = [] # to store the list of strings
    operator_list = ["AND", "OR", "NOT"] # list of operators to search
    current_phrase = "" # empty string to built the phrase if
    tuple_list = [] # new empty tuple list
    for word in individual_words_list:
        if word not in operator_list: 
            current_phrase = current_phrase + " " + word
            lowercase_current_phrase = current_phrase.lower() # return all lowercase
            clean_current_phrase = lowercase_current_phrase.strip() # remove extra white space
        else: # else condition is if the word is in the operator list
            operator = word
            token_list.append(clean_current_phrase) # append to list 
            token_list.append(operator)
            current_phrase = "" # "reset" current_phrase list
    token_list.append(clean_current_phrase) # append anything remaining in the current_plase to the token_list
    # print(token_list) # for checking!!
    for i in range(0, len(token_list), 2): # create a list of tuples, go through by 2s
        if i == 0: # first tuple condition
            first_tuple = (None, token_list[0])
            tuple_list.append(first_tuple)
        else:
            new_tuple = (token_list[i-1], token_list[i])
            tuple_list.append(new_tuple)
    return tuple_list

# correctness_check_list
correctness_check_list = [
    (2022, 1, 1, "lions", "[2022]"),
    (2022, 1, 1, "tigers", "[2022]"),
    (2022, 1, 1, "bears", "[2022]"),
    (2022, 1, 1, "lions tigers", "[2022]"),
    (2022, 1, 1, "tigers bears", "[2022]"),
    (2022, 1, 1, "lions bears", "[2022]"),
    (2022, 1, 1, "lions tigers bears", "[2022]"),
]


# def has_title_in_list(), returns bool
def has_title_in_list(book_title_string, list_checkout_record_tuples):
    book_title_string.lower() # call lowercase version 
    list_of_records = [True for record in list_checkout_record_tuples if book_title_string in record[3]]
    return bool(list_of_records)

# def get_search_results()

def get_search_results(user_search_query_string, record_list): # accepts a string that is a user search and a list of checkout record tuples
    user_search_query_string.lower() # make sure that the user inputted string is lowercase
    user_search_query_tuples = parse_search_query(user_search_query_string) # turn second string argument into a list of tuples
    results_so_far = []
    final_results = []

    for criteria in user_search_query_tuples: # loop through each tuple in the list of search phrase tuples
        if criteria[0] == None:
            for record in record_list: # loop through whole record record_list
                if criteria[1] in record[3].lower():
                    results_so_far.append(record)
        elif criteria[0] == "AND":
            items_to_keep = [result for result in results_so_far if criteria[1] in record[3].lower()]
            results_so_far = items_to_keep
        elif criteria[0] == "NOT":
            items_to_keep = [result for result in results_so_far if criteria[1] not in record[3].lower()]
            results_so_far = items_to_keep
        elif criteria[0] == "OR":
            for result in results_so_far:
                is_results_so_far_duplicate = has_title_in_list(result[3], final_results) # checks if it is a duplicate, returns a bool
                if not is_results_so_far_duplicate:
                    final_results.append(result)
            results_so_far = []
            for record in record_list:
                if criteria[1] in record[3].lower():
                    results_so_far.append(record)

    # print(results_so_far)
    for record in results_so_far:
        is_final_results_duplicate = has_title_in_list(record[3], final_results)
        if not is_final_results_duplicate: # checks if duplicate, returns a bool
            final_results.append(record)

    return final_results

get_search_results("lions OR tigers", correctness_check_list) # call the function to test
