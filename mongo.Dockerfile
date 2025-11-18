FROM mongo:8.2.1

# Create the destination directory
RUN mkdir -p /etc/mongo-keyfile

# Copy the keyfile (note: copying from the directory containing the file)
COPY mongodb/keyfile/mongodb-keyfile/mongodb-keyfile /etc/mongo-keyfile/mongodb-keyfile

# Set strict permissions
RUN chmod 700 /etc/mongo-keyfile && \
    chmod 600 /etc/mongo-keyfile/mongodb-keyfile && \
    chown -R 999:999 /etc/mongo-keyfile