FROM python:3.12.11-alpine3.22

# Define o diretório de trabalho no contêiner para /app.
# Todos os comandos subsequentes (COPY, RUN, CMD) serão executados a partir deste diretório.
WORKDIR /app

# Copia o arquivo de dependências primeiro.
# Isso aproveita o cache de camadas do Docker. Se o requirements.txt não mudar,
# o Docker reutilizará a camada de dependências instaladas, acelerando builds futuros.
COPY requirements.txt .

# Instala as dependências do projeto.
# --no-cache-dir: Não armazena o cache do pip, o que ajuda a manter o tamanho da imagem menor.
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo o código-fonte do seu projeto para o diretório de trabalho (/app) no contêiner.
COPY . .

# Expõe a porta 8000, que é a porta padrão que o Uvicorn usará para servir a aplicação.
EXPOSE 8000

# Comando para executar a aplicação FastAPI com Uvicorn quando o contêiner iniciar.
# --host 0.0.0.0: Torna a aplicação acessível a partir do seu host e não apenas de dentro do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
