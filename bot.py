import discord
import requests

import api_key
import service_url

from discord.ext import tasks

client = discord.Client()

@client.event
async def on_ready():
    print(f'We have logged in as {client.user}')


@tasks.loop(minutes=30.0, count=None)
async def update_results():
    response = requests.get(service_url.flask + '/api/tournament/latest/results').json()
    await channel.send(f"@everyone\n{response}")


@client.event
async def on_message(message):
    if message.author == client.user:
        return

    global channel

    if message.content.startswith('!enable updates'):
        channel = message.channel
        update_results.start()
        return

    if message.content.startswith('!disable updates'):
        update_results.stop()
        return

    response = get_response(message.author.id, message.content)
    try:
        text = response[0]['text']
    except:
        text = "Oopsie! An error occured, my bad :("

    await message.channel.send(text)


def get_response(sender, message):
    url = service_url.rasa + '/webhooks/rest/webhook'
    payload = { 'sender': sender, 'message': message }
    try: 
        response = requests.post(url, json=payload).json()
    except:
        print("An error occured while sending message to rasa api!")
        response = []

    return response


client.run(api_key.discord)    
