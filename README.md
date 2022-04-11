# Python assignment -- chatbot

Discord chatbot made with Rasa.

## Features

Firstly chatbot seems to work... and there is 'more'! It has:

- 4 story lines handling new users, chatbot tries to make new players intrested in e-sport tournaments.
- 3 special rules, taking action immediately:
    - getting tournaments list,
    - getting selected tournament details,
    - signing up player for selected tournament.
- special commands ```!enable updates``` and ```!disable updates``` that toggle tournament updates.

To perform listed actions bot connects to fake API. 
Tournament updates are performed every 30 minutes when enabled. 

## Prerequisites

Project requires *rasa*, *discord* and *flask* packages.

```cmd
pip install rasa discord flask
```

Before running a model have to be trained.

```cmd
rasa train
```

## Run

Bot needs couple of services in order to work properly. Those are: *rasa server*, *rasa actions server*, flask *mock api* and *bot script* itself.

```cmd
rasa run --enable-api
rasa run actions
python api.py
python bot.py
```

There is a batch file - *run.bat* which automates the process on Windows. It requires virtual environment configured inside the root directiory. 
