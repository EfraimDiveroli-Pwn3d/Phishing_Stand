import Milter
import uuid
import logging
import sys
import re

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

class GoPhishMilter(Milter.Milter):
    def __init__(self):
        self.message_id = None
        self.new_message_id = None
        self.base_fqdn = "mx01.yandex.com"
        self.id = Milter.uniqueID()

    def header(self, name, value):
        if name.lower() == 'message-id':
            self.message_id = value

            local_part = value.split('@')[0].strip('<> ')
            fqdn_part = value.split('@')[1].strip('<> ')

            is_numeric_dotted = re.match(r'^\d+(\.\d+)+$', local_part)

            if 'gophish' in value.lower() or is_numeric_dotted:
                self.new_message_id = f"<{str(uuid.uuid4())}@{fqdn_part}>"
                logging.info(f"Marked Message-Id for replacement: {value} -> {self.new_message_id}")

        return Milter.CONTINUE

    def eom(self):
        if self.new_message_id:
            self.chgheader('Message-Id', 1, self.new_message_id)
            logging.info(f"Successfully replaced Message-Id in eom")

        elif not self.message_id:
            new_message_id = f"<{str(uuid.uuid4())}@{self.base_fqdn}>"
            self.addheader('Message-Id', new_message_id)
            logging.info(f"Added new Message-Id: {new_message_id}")

        return Milter.ACCEPT


def main():
    socket_name = "inet:8892@0.0.0.0"

    Milter.factory = GoPhishMilter
    Milter.set_flags(Milter.ADDHDRS | Milter.CHGHDRS)

    print(f"Starting GoPhish Milter on {socket_name}")
    sys.stdout.flush()

    Milter.runmilter("gophishmilter", socket_name, 60)
    print("Milter shutdown")


if __name__ == "__main__":
    main()