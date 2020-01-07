### init logging ###
import logging
LOG_FORMAT = ('%(levelname) -5s %(asctime)s %(name)s:%(funcName) -35s %(lineno) -5d:  %(message)s')
logging.basicConfig(level=logging.INFO, format=LOG_FORMAT)
LOGGER = logging.getLogger(__name__)

#############################
import connexion

# load swagger config 
app = connexion.App(__name__, specification_dir='configs/')
app.add_api('swagger.yml')

@app.route('/', methods=['GET'])
def api_root():
    return 'Flocker main page.'

# start app
if __name__ == '__main__':    
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=True) 
