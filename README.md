# Python assignment -- chatbot

Discord chatbot made with Rasa.

## Prerequsites

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

There is a batch file *run.bat* which automates this process on Windows. It requires virtual environment configured inside the root directiory. 
