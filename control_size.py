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

    def __get_size(self, path: str) -> int:
        total_size = 0
        if os.path.isfile(path):
            total_size = os.path.getsize(path)
        elif os.path.isdir(path):
            for dirpath, dirnames, filenames in os.walk(path):
                for f in filenames:
                    fp = os.path.join(dirpath, f)
                    # Skip if it is symbolic link
                    if not os.path.islink(fp):
                        total_size += os.path.getsize(fp)
        return total_size

    def __check_size(self) -> None:
        while True:
            for obj in self.control_objects:
                try:
                    obj_path = os.path.expanduser(obj)
                    if os.path.exists(obj_path):
                        file_size = self.__get_size(obj_path)
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
