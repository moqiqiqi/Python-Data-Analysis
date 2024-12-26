# -*- coding: utf-8 -*-
"""
Created on Dec 25 22:03 2024
@author: Chie
"""

import pandas as pd

# loading the Final data from Task 1
final_report = pd.read_csv('cleaned_financial_data.csv')
summary_report = pd.read_csv('summary.csv')


# Creating a basic Rule-based Logic AI-Driven Chatbot
def financial_chatbot(query):
    final_data = final_report[(final_report['Year'] == fiscal_year) & (final_report['Company'] == company)]
    responses = {
        "total revenue": f"The net income for {company} in the fiscal year {fiscal_year} was"\
                         f"{final_data['Total Revenue']}",
        "revenue growth": f"The revenue grew by {final_data['Revenue Growth (%)']}% in {fiscal_year}.",
    }
    return responses.get(query.lower(), "I'm not sure how to answer that. Can you try a different question?")


while True:
    print("----------------------------------------------------------------------------")
    print("Hi! Welcome to AI-Driven Financial Chatbot!")
    print("I can help you with your financial performance queries about Apple, Microsoft, and Tesla"\
          "in the last three years.")
    user_input = input('Enter Hi to start session or enter exit to quit:')
    if user_input.lower() == 'hi':
        while True:
            company = input("Enter company name: ").capitalize()
            if company not in ['Apple', 'Microsoft', 'Tesla']:
                print("Invalid Company Name. Please check and enter again")
            else:
                break
        while True:
            fiscal_year = int(input("Type the fiscal year you want to explore: "))
            if fiscal_year not in [2023, 2022, 2021]:
                print("Please enter a valid fiscal year")
            else:
                break
        while True:
            query = input("Please enter the performance metrics you would like to query or enter exit to quit:")
            if query.lower() == 'exit':
                break
            print(financial_chatbot(query))
    elif user_input.lower() == 'exit':
        break
    else:
        print("I can not understand. Could you please check and type again?")
