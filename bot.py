import discord
import requests

import api_key
import service_url

client = discord.Client()

@client.event
async def on_ready():
    print(f'We have logged in as {client.user}')


@client.event
async def on_message(message):
    if message.author == client.user:
        return

    response = get_response(message.author.id, message.content)
    try:
        text = response[0]['text']
    except:
        text = "Oopsie! An error occured, my bad :("

    #await message.channel.send(f'{message.content}, <@{message.author.id}>')
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
