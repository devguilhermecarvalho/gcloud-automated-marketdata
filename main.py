import functions_framework
import pandas as pd
import yfinance as yf
from google.cloud import storage
from flask import make_response
from datetime import datetime

# Fuções importadas:
from functions import get_historical_market_data, bronze_market_data

@functions_framework.http
def main(request):
    """
    Função principal para obter, transformar e armazenar dados históricos do mercado de ações no Google Cloud Storage.
    """
    # Inicializa e executa o processo de obtenção de dados históricos
    
    data_fetcher = get_historical_market_data.GetHistoricalData(request) # Instancia a classe GetHistoricalData
    fetch_response = data_fetcher.get_historical_data() # Executa a função da classe

    if fetch_response.status_code == 200: # Se a resposta for positiva, inicia-se o processo de transformação:
        data_transformer = bronze_market_data.TransformMarketData(request) # Instancia a classe TransformMarketData
        transform_response = data_transformer.transform_and_save_market_data()

        return transform_response
    else:
        return fetch_response