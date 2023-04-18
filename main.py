import platform
import json
import argparse
import os


class AutomateDownload:
	def __init__(self, location = "") -> None:
		self.location = location

	def get_links(self):
		file = open("list.json")
		return json.load(file)
	
	def start(self):
		platform_system = 'linux' if platform.system() == 'Linux' else 'windows'
		links = self.get_links()[platform_system]
		command = "wget {link} -o {output}".format(link=links['go'], output=self.location)
		os.system(command)
		os.system("wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash")
			
if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-o", "--output", help="Output location file", type=str)
	args = parser.parse_args()

	auto = AutomateDownload(args.output)
	auto.start()