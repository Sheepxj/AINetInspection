import yaml
def read_config():
    with open('config/config.yaml', 'r', encoding='utf-8') as file:
        return yaml.safe_load(file)

def read_config_port():
    with open('config/pyid.yaml', 'r', encoding='utf-8') as file:
        config = yaml.safe_load(file)
        msg_config = config['pymsg']
        pyid = msg_config['pyid']
        return pyid