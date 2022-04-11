# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

import requests
import service_url

class ActionHelloWorld(Action):

    def name(self) -> Text:
        return "action_hello_world"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        response = requests.get(service_url.flask + '/api/hello').json()

        dispatcher.utter_message(text=response['text'])

        return []


class ActionShowActiveTournaments(Action):

    def name(self) -> Text:
        return "action_show_active_tournaments"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        response = requests.get(service_url.flask + '/api/tournaments').json()

        msg = 'Currently those tournaments are open:'

        for number, title in response.items():
            msg += f'\n*#{number} {title}*'

        msg += '\nYou can ask for details or sign up providing **#number**'

        dispatcher.utter_message(text=msg)

        return []


class ActionProvideTournamentDetails(Action):

    def name(self) -> Text:
        return "action_provide_tournament_details"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        num = next(tracker.get_latest_entity_values("num"), None)

        response = requests.get(service_url.flask + '/api/tournament/' + num + '/details').json()

        msg = f'*{response}*\nWould you like to join? Provide **#number**'

        dispatcher.utter_message(text=msg)

        return []


class ActionTryToSignUp(Action):

    def name(self) -> Text:
        return "action_try_to_sign_up"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        num = next(tracker.get_latest_entity_values("num"), None)

        post_data = { 'user_id': tracker.sender_id }

        response = requests.post(service_url.flask + '/api/tournament/' + num + '/join', post_data).json()

        msg = f"<@{response['user_id']}> has just signed up for {response['title']}!\n*{response['details']}*\nGood luck!"

        dispatcher.utter_message(text=msg)

        return []

