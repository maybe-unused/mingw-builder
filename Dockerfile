FROM ghcr.io/maybe-unused/mms-mingw:1.0

RUN conan --version
WORKDIR /root/.conan2/profiles
COPY conan-mingw .
COPY mingw_conan.cmake .

RUN apt install -y curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add x86_64-pc-windows-gnu
RUN apt-get install -y mingw-w64
RUN cargo install just
RUN conan profile detect
WORKDIR /usr/local/bin

# This needed for msvcrt110 library
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x winetricks
RUN apt-get install -y wine64

RUN export WINDIR="/usr/lib/x86_64-linux-gnu/wine/x86_64-windows"
RUN echo "export WINDIR=\"${WINDIR}\"" >> /root/.bashrc
RUN echo "export PATH=\"${PATH}\"" >> /root/.bashrc
