import argparse
import json
import os


CONFIG_FILE = os.path.dirname(os.path.abspath(__file__)) + '/config.json'


class ConfigWriter:

    control_obj: list[str, ...] = ''
    size: int = 0
    json_data: dict = None

    def __init__(self):
        with open(file=CONFIG_FILE, mode='r', encoding='utf-8') as cf:
            self.json_data = json.load(cf)
        self.control_obj = self.json_data['files']
        self.size = self.json_data['size']

    def set_size(self, size: int) -> None:
        self.size = size

    def set_ctrl_obj(self, obj: str) -> None:
        self.control_obj = []
        self.control_obj.append(obj)

    def append_ctrl_obj(self, obj: str) -> None:
        if obj not in self.control_obj:
            self.control_obj.append(obj)
        else:
            print('Can append only unique objects:c')

    def write_config(self) -> None:
        self.json_data['files'] = self.control_obj
        self.json_data['size'] = self.size
        with open(file=CONFIG_FILE, mode='w', encoding='utf-8') as cf:
            json.dump(self.json_data, cf, ensure_ascii=False, indent=4)


def main() -> None:
    cw = ConfigWriter()
    parser = argparse.ArgumentParser(description='Write config of size controller')
    parser.add_argument('-ss', '--size', help='Set custom size to config', nargs='?', const=10737418240)
    parser.add_argument('-scf', '--scontrolfile', help='Set custom obj to config', nargs='?', const='~/0g-storage-node/run/log')
    parser.add_argument('-acf', '--acontrolfile', help='Add custom obj to config', nargs='?', const='~/0g-storage-node/run/log')

    args = parser.parse_args()

    if args.size:
        cw.set_size(args.size)
    if args.scontrolfile:
        cw.set_ctrl_obj(args.scontrolfile)
    elif args.acontrolfile:
        cw.append_ctrl_obj(args.acontrolfile)
    cw.write_config()


if __name__ == "__main__":
    main()
