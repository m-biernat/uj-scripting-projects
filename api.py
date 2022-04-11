from flask import Flask, jsonify, request

import random

app = Flask(__name__)

@app.route('/api/hello', methods=['GET'])
def hello():
    return jsonify({'text': 'Hello World!'})


tournaments = {
    '1': 'Counter-Strike: Global Offensive - MIX - Bo5',
    '2': 'Counter-Strike: Global Offensive - Deathmatch - Bo3',
    '3': 'League of Legends - ARAM - 1 vs 1'
}

tournament_details = {
    '1': 'In this Counter-Strike:Global Offensive tournament 5 random maps will be played.'\
         '\nTeams are not predefined, players are randomly mixed together.'\
         '\nA team scoring the most points on those maps will win.'\
         '\nCurrently the tournament is in qualification phase. The best two teams will meet in the final!',
    '2': 'In this Counter-Strike:Global Offensive tournament 3 random maps will be played.'\
         '\nThere are no teams, players are randomly mixed for a total of 10 per map.'\
         '\nA player scoring the most points on those maps will win.'\
         '\nCurrently the tournament is in qualification phase. Top 5 players will meet in the final!',
    '3': 'In this League of Legends tournament only one game mode will be played.'\
         '\nThere are no teams, players are randomly fighting in 1 vs 1 All Random All Mid battles.'\
         '\nA player winning the most matches will be a champion!'\
         '\nCurrently the tournament is in qualification phase. The best players will met in the final!',
}

@app.route('/api/tournaments', methods=['GET'])
def get_tournaments():
    return jsonify(tournaments)
                           

@app.route('/api/tournament/<number>/details', methods=['GET'])
def get_tournament_details(number):
    return jsonify(tournament_details[number])


@app.route('/api/tournament/<number>/join', methods=['POST'])
def post_tournament_join_request(number):
    data = { 'user_id': request.form['user_id'], 'title': tournaments[number], 'details': tournament_details[number] }
    return jsonify(data)


@app.route('/api/tournament/latest/results', methods=['GET'])
def tournament_latest_results():
    rand_title = random.choice(list(tournaments.values()))
    rand_int = random.randint(10, 150)
    data = f'{rand_title} has {rand_int} registered players!'\
            '\nHurry up, it will start soon!'
    return jsonify(data)


app.run()
