FROM ubuntu 
ARG wiki_date=20190501
ARG wiki_lang=tr
RUN echo "Selected language $wiki_lang, Selected data $wiki_date"
RUN apt update && apt install -y wget unzip curl bzip2 git apt-utils sed make vim
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda create -n wiki-proc python=3.7 && bash -c "source activate wiki-proc && conda install -y pip spacy && pip install bs4 && pip install hanziconv"
RUN echo "source activate wiki-proc" > ~/.bashrc
RUN mkdir /workspace/ && cd /workspace/ && git clone https://github.com/attardi/wikiextractor && git clone https://github.com/shyamupa/wikidump_preprocessing 
RUN cd /workspace/wikidump_preprocessing \
    && sed -i "s/\/Users\/nicolette\/Documents\/nlp-wiki\/dumpdir/\/workspace\/dumpdir/g" makefile \
    && sed -i "s/\/Users\/nicolette\/Documents\/nlp-wiki\/outdir/\/workspace\/outdir/g" makefile \
    && sed -i "s/\/Users\/nicolette\/Documents\/nlp-wiki\/wikiextractor/\/workspace\/wikiextractor/g" makefile \
    && sed -i "s/\/Users\/nicolette\/anaconda2\/envs\/py3\/bin\/python/\/miniconda\/envs\/wiki-proc\/bin\/python/g" makefile \
    && sed -i "s/DATE=20190501/DATE=$wiki_date/g" makefile \
    && sed -i "s/lang=tr/lang=$wiki_lang/g" makefile
WORKDIR /workspace
