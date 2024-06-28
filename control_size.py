import os
import threading
import time
import json


class Controller:
    control_objects: list = None
    size: int = None
    main_thr: threading.Thread = None

    def __init__(self, *args, **kwargs) -> None:
        self.control_objects = kwargs.get('files', [])
        self.size = kwargs.get('size', 0)
        self.main_thr = threading.Thread(target=self.__check_size)

    def __check_size(self) -> None:
        while True:
            for obj in self.control_objects:
                try:
                    obj_path = os.path.expanduser(obj)
                    if os.path.exists(obj_path):
                        file_size_str = os.popen("ls -l %s | awk '{print $5}'" % obj_path).read().strip().replace('0\n', '')
                        file_size = int(file_size_str)
                        if file_size >= self.size:
                            if os.path.isdir(obj_path):
                                for file in os.listdir(obj_path):
                                    file_path = os.path.join(obj_path, file)
                                    if os.path.isfile(file_path):
                                        with open(file_path, 'w') as f:
                                            f.write('')
                            else:
                                with open(obj_path, 'w') as f:
                                    f.write('')

                except Exception as e:
                    print(f"Error processing {obj}: {str(e)}")
            time.sleep(2)

    def start(self) -> None:
        self.main_thr.start()


def main():
    config_file = os.path.dirname(os.path.abspath(__file__)) + '/config.json'
    with open(config_file, 'r', encoding='utf-8') as cf:
        data = json.load(cf)
    ctr = Controller(**data)
    ctr.start()


if __name__ == "__main__":
    main()
