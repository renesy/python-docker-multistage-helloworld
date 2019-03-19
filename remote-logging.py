import logging
import logging.handlers

logger = logging.getLogger('MyLogging')
http_handler = logging.handlers.HTTPHandler('127.0.0.1:8000', '/logger', method='POST')
logger.addHandler(http_handler)

# Log messages:
logger.warning('Log Message Warn')
logger.error("Log Message Error")