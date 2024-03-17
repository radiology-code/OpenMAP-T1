FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-runtime
WORKDIR /openmap
COPY utils utils
COPY level level
COPY models models
COPY requirements.txt requirements.txt
COPY entrypoint entrypoint
COPY parcellation.py parcellation.py
RUN pip install --upgrade pip && pip install -r requirements.txt
RUN mkdir /input
RUN mkdir /output
ENV PYTHONPATH /openmap
RUN chmod +x entrypoint
CMD ["./entrypoint"]

