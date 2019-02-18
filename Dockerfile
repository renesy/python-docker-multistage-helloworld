FROM alpine:3.8 AS builder

ENV LANG C.UTF-8

# This is our runtime
RUN apk add --no-cache python3

# This is dev runtime
RUN apk add --no-cache --virtual .build-deps build-base python3-dev
# Using latest versions, but pinning them
RUN pip3 install --upgrade pip setuptools pipenv

# This is where pip will install to
ENV PYROOT /pyroot
# A convenience to have console_scripts in PATH
ENV PATH $PYROOT/bin:$PATH
ENV PYTHONUSERBASE $PYROOT

WORKDIR /build

# Install dependencies
COPY Pipfile Pipfile.lock ./
RUN PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install --system --deploy
# Install our application
COPY . ./
RUN pip install --user .

####################
# Production image #
####################
FROM alpine:3.8 AS prod

RUN apk add --no-cache python3

ENV PYROOT /pyroot
ENV PATH $PYROOT/bin:$PATH
ENV PYTHONPATH $PYROOT/lib/python:$PATH
# This is crucial for pkg_resources to work
ENV PYTHONUSERBASE $PYROOT

# Finally, copy artifacts
COPY --from=builder $PYROOT/lib/ $PYROOT/lib/
# In most cases we don't need entry points provided by other libraries
COPY --from=builder $PYROOT/bin/helloworld_in_python $PYROOT/bin/

CMD ["helloworld_in_python"]

#total size 57.5MB