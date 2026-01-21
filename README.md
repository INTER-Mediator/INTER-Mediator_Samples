# INTER-Mediator_Samples

by INTER-Mediator Directive Committee (https://inter-mediator.org)

INTER-Mediator is the new style web application framework.
You can develop easily and realize your ideals.
You describe table and field names in any HTML elements,
and these are bond to the database, showing values moreover automatically update with editing.
If you want to implement more complex logic, you can write programs both client and server sides.

The main repository of INTER-Mediator is NOT here, this repository is only for samples.

INTER-Mediator:
- https://github.com/INTER-Mediator/INTER-Mediator

All information about INTER-Mediator can be available at:
- https://inter-mediator.com/
- https://inter-mediator.info/

Everyone can see sample pages working with the database.
You don't have to deploy the samples if you just want to see this at a glance.

The runnable version of the demo with the latest version of INTER-Mediator is here:
- https://demo.inter-mediator.com/INTER-Mediator_Samples/

## How to let them work on

Installation of this repository is as follows:
```
git clone https://github.com/INTER-Mediator/INTER-Mediator_Samples
cd INTER-Mediator_Samples
composer install
composer update
```

These processes set up other software required to run the samples.
You can run the samples with command ```php -S localhost:9000``` and access to ```http://localhost:9000```.
The top page of the samples has links to each sample.

## How to work on the main repository

If you want to work on the main repository with the samples, you can do it with the following steps.
```
git clone https://github.com/INTER-Mediator/INTER-Mediator
cd INTER-Mediator
composer install
composer update
git clone https://github.com/INTER-Mediator/INTER-Mediator_Samples samples
cd samples
mkdir -p ../vendor/inter-mediator
cd ../vendor/inter-mediator
ln -s ../../../ inter-mediator
```

The first 4 steps are the same as the installation of INTER-Mediator.
After that, the samples are stored in the "samples" directory at the root of the INTER-Mediator repository.
For sample files to refer to the valid files in the INTER-Mediator, one symbolic link has to be created.
