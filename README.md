# Usage
This repo has been refactored to use `pipenv` and a simplified Docker file image to run the contained code.  It should be more reproducible in the future. 

This assumes you have docker and docker-compose installed.  On Windows, compose comes packaged with Docker for Windows.  You can also install it manually via the [compose documentation](https://docs.docker.com/compose/install/).

To build:
```
docker-compose build
```

To run:
```
docker-compose up
```
A jupyter server will be available at http://localhost:9888/lab. 

### Env Variables and GPUs
There is an example environment variable file called `example.env` in the root of the repository.  Rename this to `.env` and *do not* commit it to git.  You can also store secrets here if necessary.  There currently are two variables:
* NVIDIA_VISIBLE_DEVICES:  Maps to the GPU number you want visible.  Set to `all` if you want all of them.  
* RUNTIME: use `nvidia` to have GPU capabilities.  Use `runc` for machines without it.  

Running with GPU support requires the [nvidia-container-runtime](https://github.com/NVIDIA/nvidia-container-runtime) is installed and working on the host machine.  Note that because tensorflow 1.x split gpu and non-gpu capabilities it may not work on non-gpu enabled machines. 

### Running specific scripts
There are several scripts included in the repo.  Use the `drun_app` bash shortcut if running from bash to run specific programs and not run jupyter. 

```
./drun_app python script.py
```

Or without the shortcut:
```
docker-compose run app python script.py
```

### Data
The original code expects data at `/data`.  The compose file maps `./data` => `/data` in the container automatically.  The full working directory is also mounted at `/app`.  

### Updating pipenv dependencies 
If code dependencies need to be updated, use `pipenv` from within the container to update the `Pipfile.lock` then rebuild the container.

```
# using the utility entrypoint if using bash
./drun_app pipenv install NEW_PACKAGE
docker-compose build
```
Or if not using bash:
```
docker-compose run app pipenv install NEW_PACKAGE
docker-compose build
```

More information on Pipenv is available on the [documentation page](https://pipenv.kennethreitz.org/en/latest/). 

# Privacy-preserving generative deep neural networks support clinical data sharing

Brett K. Beaulieu-Jones<sup>1</sup>, Zhiwei Steven Wu<sup>2</sup>, Chris Williams<sup>3</sup>, Casey S. Greene<sup>3</sup>*

<sup>1</sup>Genomics and Computational Biology Graduate Group, Perelman School of Medicine, University of Pennsylvania, Philadelphia, Pennsylvania, USA.

<sup>2</sup>Computer and Information Science, School of Engineering and Applied Sciences, University of Pennsylvania, Philadelphia, Pennsylvania, USA.

<sup>3</sup>Department of Systems Pharmacology and Translational Therapeutics, Perelman School of Medicine, University of Pennsylvania, Philadelphia, Pennsylvania, USA.

To whom correspondence should be addressed: csgreene (at) upenn.edu

### https://doi.org/10.1101/159756

Introduction
--------
Though it is widely recognized that data sharing enables faster scientific progress, the sensible need to protect participant privacy hampers this practice in medicine. We train deep neural networks that generate synthetic subjects closely resembling study participants. Using the SPRINT trial as an example, we show that machine-learning models built from simulated participants generalize to the original dataset. We incorporate differential privacy, which offers strong guarantees on the likelihood that a subject could be identified as a member of the trial. Investigators who have compiled a dataset can use our method to provide a freely accessible public version that enables other scientists to perform discovery-oriented analyses. Generated data can be released alongside analytical code to enable fully reproducible workflows, even when privacy is a concern. By addressing data sharing challenges, deep neural networks can facilitate the rigorous and reproducible investigation of clinical datasets.

First run Preprocess.ipynb on the SPRINT clinical trial data (https://challenge.nejm.org/pages/home)

The results in the paper use:

`python dp_gan.py --noise 1 --clip_value 0.0001 --epochs 500 --lr 2e-05 --batch_size 1 --prefix 1_0.0001_2e-05_ `

Due to GPU threading, the current lack of an effective way to set a random seed for tensorflow, and the fact that we are optimizing two neural networks (unlikely to find global minima) it may require running multiple times to hit a good local minimum.

<img src="https://github.com/greenelab/SPRINT_gan/raw/master/figures/Figure_2A.png?raw=true" alt="Fig 2A" width="300"/><img src="https://github.com/greenelab/SPRINT_gan/raw/master/figures/Figure_2B.png?raw=true" alt="Fig 2B" width="300"/>
<img src="https://github.com/greenelab/SPRINT_gan/raw/master/figures/Figure_2C.png?raw=true" alt="Fig 2C" width="300"/><img src="https://github.com/greenelab/SPRINT_gan/raw/master/figures/Figure_2D.png?raw=true" alt="Fig 2D" width="300"/>

**Median Systolic Blood Pressure Trajectories from initial visit to 27 months.** **A.)** Simulated samples (private and non-private) generated from the final (500th) epoch of training. **B.)** Simulated samples generated from the epoch with the best performing logistic regression classifier. **C.)** Simulated samples from the epoch with the best performing random forest classifier. **D.)** Simulated samples from the top five random forest classifier epochs and top five logistic regression classifier epochs.


Feedback
--------

Please feel free to email us - (brettbe) at med.upenn.edu with any feedback or raise a github issue with any comments or questions.

Acknowledgements
----------------
Acknowledgments: We thank Jason H. Moore (University of Pennsylvania), Aaron Roth (University of Pennsylvania), Gregory Way (University of Pennsylvania), Yoseph Barash (University of Pennsylvania) and Anupama Jha (University of Pennsylvania) for their helpful discussions. We also thank the participants of the SPRINT trial and the entire SPRINT Research Group for providing the data used in this study. Funding: This work was supported by the Gordon and Betty Moore Foundation under a Data Driven Discovery Investigator Award to C.S.G. (GBMF 4552). B.K.B.-J. Was supported by a Commonwealth Universal Research Enhancement (CURE) Program grant from the Pennsylvania Department of Health and by US National Institutes of Health grants AI116794 and LM010098. Z.S.W is funded in part by a subcontract on the DARPA Brandeis project and a grant from the Sloan Foundation. 
