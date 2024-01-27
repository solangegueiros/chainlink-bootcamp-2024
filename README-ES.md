# Chainlink Bootcamp 2024 - Ejercicios

- [In English](README-ES.md)
- [Em Português](README-PT.md)

Todas las sesiones en Español: 
[Luma](https://lu.ma/fkr85zi7)

- [Chainlink Documentation](https://docs.chain.link/)
- [Chainlink Developer Hub](https://dev.chain.link/)
- [Slides](https://docs.google.com/presentation/d/e/2PACX-1vSWSZfMuNAjQrRFEsUXZad1j-1POA_XlGpsXfy0uQmwAhFjBxyysJ8Y8xKL18FGu77NXFfovotT90F2/pub?start=false&loop=false&delayms=3000)

[Task Form](https://forms.gle/N8eAXAaSE5WzPd1t7) - 
Hasta 2024 Jan 31

## Clase 1 - Fundamentos de blockchain, Web3 y Billeteras

Ver en [Youtube](https://www.youtube.com/watch?v=1SNmVktaagU)

### 1- Dirección de la Cuenta 1 de la Billetera

Instalar [Metamask](https://metamask.io/).

Configurar Metamask con una nueva cartera (nueva frase semilla), no utilizada para fondos de Mainnet. 

Copiar la dirección de la Cuenta1 - Account1.

### 2- Deposita fondos en tu Billetera y obtiene el hash de la transacción

Ve a un faucet y consigue ETH de Sepolia

Opciones:
- [Chainlink faucet](https://faucets.chain.link/)
- [Sepolia faucet](https://sepolia-faucet.pk910.de/)

Obtenga la identificación de la transacción donde recibe el ETH.

¿Cómo hacerlo?
Ve al Explorador de Bloques de Sepolia, busca la dirección de tu cuenta 1 / billetera

Sepolia Block Explorer:
- [Etherscan](https://sepolia.etherscan.io/)

Obtenga la transacción que quien esta haciendo el depositoen tu billetera.

### 3- Transaction hash - transfer

Crea una nueva cuenta, llamada Cuenta2.
Transfiera 0.1 Sepolia ETH de la Cuenta1 a la Cuenta2.

Obtenga la identificación de la transacción y compártala.


## Clase 2 - Fundamentos de Solidity

Ver en [Youtube](https://www.youtube.com/watch?v=c5YwxmuWIcw)

### 4- Register Smart Contract Address

[Register.sol](Register.sol)

### 5- RegisterAccess Smart Contract Address

[RegisterAccess.sol](RegisterAccess.sol)


## Clase 3 - Oracles (Oráculos), tokens ERC20 y Chainlink Data Feeds

Ver en [Youtube](https://www.youtube.com/watch?v=E1sBc1YFgus)

### 6- Token Address

[Token.sol](Token.sol)

### 7- TokenShop Address

[TokenShop.sol](TokenShop.sol)


## Clase 4 - Interoperabilidad con tokens usando Chainlink CCIP

Ver en [Youtube](https://www.youtube.com/watch?v=5IFeP0gdcpM)

### 8- CCIPTokenSenderFujiSepolia Address

Implementarlo en Avalanche Fuji.

[CCIPTokenSenderFujiSepolia.sol](CCIPTokenSenderFujiSepolia.sol)


## Clase 5 - Mentoría con la comunidad Chainlink

Ver en [Youtube](https://www.youtube.com/watch?v=xSfTQ66qUm0)


## Clase 6 - NFTs y Chainlink Automation

Ver en [Youtube](https://www.youtube.com/watch?v=WjBmwy5NDgU)

### 9- PhotoAlbum  Address

[PhotoAlbum.sol](PhotoAlbum.sol)

### 10- Automation URL para tu job

Obtenga la URL de tu job creado en [Chainlink Automation](https://automation.chain.link/) relacionado con la automatización del photo album.


## Clase 7 - Interoperabilidad en NFTs usando Chainlink CCIP

Ver en [Youtube](https://www.youtube.com/watch?v=XjzJtD2ySQ0)

### 11- CrossChainPriceNFT address

Implementarlo en Ethereum Sepolia.

[CrossChainPriceNFT.sol](CrossChainPriceNFT.sol)

### 12- CrossDestinationMinter address

Implementarlo en Ethereum Sepolia.

[CrossDestinationMinter.sol](CrossDestinationMinter.sol)

### 13- CrossSourceMinter address

Implementarlo en Avalanche Fuji.

[CrossSourceMinter.sol](CrossSourceMinter.sol)

### 14- MintOnSepolia Transaction ID

MintOnSepolia Transaction ID - CCIP transaction


## Clase 8 - Números aleatorios usando Chainlink VRF

Ver en [Youtube](https://www.youtube.com/watch?v=-tBZsxsE8K0)

### 15- NFT Runners address

Implementarlo en Avalanche Fuji.

[Runner.sol](Runner.sol)

### 16- VRF Id Subscription

VRF Id Subscription creado en [Chainlink VRF](https://vrf.chain.link/)


## Clase 9 - Chainlink Functions para acceder a datos fuera de las cadenas

Ver en [Youtube](https://www.youtube.com/watch?v=jK6NMxz3wvc)

### 16- Function Id Subscription

Implementarlo en Avalanche Fuji.

Function Id Subscription creado en [Chainlink Functions](https://functions.chain.link/)

Cómo utilizar la [Chainlink Documentation](https://docs.chain.link/)

### 17- GettingStartedFunctionsConsumer smart contract address

Implementarlo en Avalanche Fuji.

[GettingStartedFunctionsConsumer.sol](GettingStartedFunctionsConsumer.sol)

### 18- TemperatureFunctions smart contract address

Implementarlo en Avalanche Fuji.

[TemperatureFunctions.sol](TemperatureFunctions.sol)


## Clase 10 - Connecting the world using the Chainlink platform

Ver en [Youtube](https://www.youtube.com/watch?v=7i6gAp5Sx84)

### 19- Your WeatherFunctions smart contract address

Implementarlo en Avalanche Fuji.

[WeatherFunctions.sol](WeatherFunctions.sol)

### 20- Your transaction in Sol's smart contract WeatherFunctions 

Abra el archivo WeatherFunctions.sol y conéctese en el contrato inteligente de Sol usando **at address**

Address: 
0x4e6b427e8968de8643d0f4d556a55e538b5f1cd4

Ejecute la función **GetTemperature** para agregar tu ciudad, Temperatura en el contrato de Sol.

El objetivo es tener las ciudades/temperaturas de todos los estudiantes :)


## ¡Felicidades!

¡Lo hiciste!

Si necesitas ayuda o tienes alguna duda entra en Chainlink [Discord](https://chain.link/discord)

Channel: Espanol
