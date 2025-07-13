import json
from flask import Response

def custom_jsonify(data):
    return Response(json.dumps(data, ensure_ascii=False), mimetype='application/json')