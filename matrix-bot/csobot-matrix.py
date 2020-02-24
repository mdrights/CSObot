#!/usr/bin/env python3

# Modified: MDrights
# Forked from tiny-matrix-bot
# Changelog:
# 2019.07.21    improved as to parse and pass arguments for scripts it exec.

import os
import re
import sys
import logging
import schedule
import traceback
import subprocess
import configparser
from time import sleep
from matrix_client.client import MatrixClient

logger = logging.getLogger("csobot-matrix")
logger.setLevel(logging.DEBUG)


class TinyMatrixtBot():
    def __init__(self):
        root_path = os.path.dirname(os.path.realpath(__file__))
        self.config = configparser.ConfigParser()
        if "CONFIG" in os.environ:
            config_path = os.environ["CONFIG"]
        else:
            config_path = os.path.join(root_path, "csobot-matrix.cfg")
        self.config.read(config_path)
        self.base_url = self.config.get("csobot-matrix", "base_url")
        self.token = self.config.get("csobot-matrix", "token")
        self.connect()
        if len(sys.argv) > 1:
            if sys.argv[1] not in self.client.rooms:
                sys.exit(1)
            if len(sys.argv) == 3:
                text = sys.argv[2]
            else:
                text = sys.stdin.read()
            logger.info("send message to {}".format(sys.argv[1]))
            self.client.rooms[sys.argv[1]].send_text(text)
            logger.info("message sent, exiting")
            sys.exit(0)
        run_path = self.config.get(
            "csobot-matrix", "run_path",
            fallback=os.path.join(root_path, "run"))
        os.chdir(run_path)
        scripts_path = self.config.get(
            "csobot-matrix", "scripts_path",
            fallback=os.path.join(root_path, "scripts"))
        enabled_scripts = self.config.get(
            "csobot-matrix", "enabled_scripts", fallback=None)
        self.scripts = self.load_scripts(scripts_path, enabled_scripts)
        self.inviter = self.config.get(
            "csobot-matrix", "inviter", fallback=None)
        self.client.add_invite_listener(self.on_invite)
        self.client.add_leave_listener(self.on_leave)

        myDay = self.config.get(
            "csobot-matrix", "days", fallback=None)
        myHour = self.config.get(
            "csobot-matrix", "hours", fallback=None)
        myMinute = self.config.get(
            "csobot-matrix", "minutes", fallback=None)
        mySecond = self.config.get(
            "csobot-matrix", "seconds", fallback=None)

        if myDay:
            schedule.every(int(myDay)).day.do(self.cronjob)
        if myHour:
            schedule.every(int(myHour)).hour.do(self.cronjob)
        if myMinute:
            schedule.every(int(myMinute)).minutes.do(self.cronjob)
        if mySecond:
            schedule.every(int(mySecond)).seconds.do(self.cronjob)

        for room_id in self.client.rooms:
            self.join_room(room_id)
        self.client.start_listener_thread(
            exception_handler=lambda e: self.connect())

        while True:
            schedule.run_pending()
            sleep(1)


    def cronjob(self):
        #print('\n SENDING ...')
        for room_id in self.client.rooms:
            room = self.client.join_room(room_id)
            self.run_scripts_all(room, room_id)


    def connect(self):
        try:
            logger.info("connecting to {}".format(self.base_url))
            self.client = MatrixClient(self.base_url, token=self.token)
            logger.info("connection established")
        except Exception:
            logger.warning(
                "connection to {} failed".format(self.base_url) +
                ", retrying in 5 seconds...")
            sleep(5)
            self.connect()

    def load_scripts(self, path, enabled):
        scripts = []
        for script_name in os.listdir(path):
            script_path = os.path.join(path, script_name)
            if enabled:
                if script_name not in enabled:
                    continue
            if (not os.access(script_path, os.R_OK) or
                    not os.access(script_path, os.X_OK)):
                continue
            script_regex = subprocess.Popen(
                [script_path],
                env={"CONFIG": "1"},
                stdout=subprocess.PIPE,
                universal_newlines=True
                ).communicate()[0].strip()
            if not script_regex:
                continue
            script_env = {}
            if self.config.has_section(script_name):
                for key, value in self.config.items(script_name):
                    script_env["__" + key] = value
            script = {
                "name": script_name,
                "path": script_path,
                "regex": script_regex,
                "env": script_env
            }
            scripts.append(script)
            logger.info("script {}".format(script["name"]))
            logger.debug("script {}".format(script))
        return scripts

    def on_invite(self, room_id, state):
        sender = "someone"
        for event in state["events"]:
            if event["type"] != "m.room.join_rules":
                continue
            sender = event["sender"]
            break
        logger.info("invited to {} by {}".format(room_id, sender))
        if self.inviter:
            if not re.search(self.inviter, sender):
                logger.info(
                    "{} is not inviter, ignoring invite"
                    .format(sender))
                return
        self.join_room(room_id)

    def join_room(self, room_id):
        logger.info("join {}".format(room_id))
        room = self.client.join_room(room_id)
        #room.add_listener(self.on_room_event)

        self.run_scripts_all(room, room_id)

    def on_leave(self, room_id, state):
        sender = "someone"
        for event in state["timeline"]["events"]:
            if not event["membership"]:
                continue
            sender = event["sender"]
        logger.info("kicked from {} by {}".format(room_id, sender))

    #def on_room_event(self, room, event):
    #    if event["sender"] == self.client.user_id:
    #        return
    #    if event["type"] != "m.room.message":
    #        return
    #    if event["content"]["msgtype"] != "m.text":
    #        return
    #    args = event["content"]["body"].strip()

    def run_scripts_all(self, room, room_id):
        args = ''
        #print(args)

        for script in self.scripts:
           # if not re.search(script["regex"], args, re.IGNORECASE):
           #     logger.debug("User input is invalid")
           #     continue
           # else:
           #     real_args = ' '.join(args.split(' ')[1:])
           #     self.run_script(room, event, script, real_args)
            real_args = ' '.join(args.split(' ')[1:])
            #print(script)
            self.run_script(room, room_id, script, real_args)

    def run_script(self, room, room_id, script, args):
        logger.debug("script {}".format(script))

        #print(room_id)

        if "__whitelist" in script["env"]:
            #if not re.search(script["env"]["__whitelist"],
                             #event["room_id"]+event["sender"]):
            if not room_id in script["env"]["__whitelist"]:
                logger.debug("script not whitelisted")
                return
        if "__blacklist" in script["env"]:
            #if re.search(script["env"]["__blacklist"],
                         #event["room_id"]+event["sender"]):
            if room_id in script["env"]["__blacklist"]:
                logger.debug("script blacklisted")
                return

        logger.debug("script run {}".format([script["name"], args]))
        run = subprocess.Popen(
            [script["path"], args],
            stdout=subprocess.PIPE,
            universal_newlines=True
        )
        output = run.communicate()[0].strip()

        #print(output)

        if run.returncode != 0:
            logger.debug("script exit {}".format(run.returncode))
            return
        sleep(0.5)
        for p in output.split("\n\n"):
            for l in p.split("\n"):
                logger.debug("script output {}".format(l))
            room.send_text(p)
            sleep(0.8)


if __name__ == "__main__":
    if "DEBUG" in os.environ:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)
    try:
        TinyMatrixtBot()
    except Exception:
        traceback.print_exc(file=sys.stdout)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(1)
