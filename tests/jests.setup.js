module.exports = {
    // Define o ambiente de teste como Node.js
    testEnvironment: 'node',
    
    // Caminho para o arquivo de configuração adicional do Jest
    setupFilesAfterEnv: ['./tests/jest.setup.js'], // [[2]](https://poe.com/citation?message_id=260959467175&citation=2)
    
    // Relatórios de teste
    reporters: [
      'default',
      ['jest-html-reporters', {
        pageTitle: 'STV Voting and Campaign Finance Test Report', // Título do relatório HTML
        outputPath: './reports/test-report.html', // Caminho de saída para o relatório
        includeFailureMsg: true, // Inclui mensagens de falhas nos testes
        includeConsoleLog: true  // Inclui logs do console nos relatórios
      }]
    ],
    
    // Coleta de cobertura de código
    collectCoverage: true,
    coverageDirectory: './coverage', // Diretório onde a cobertura será armazenada
    coveragePathIgnorePatterns: ['/node_modules/', '/src/adminFunctions.js', '/src/voteCounter.js'], // Ignorar cobertura para esses arquivos
    
    // Configurações globais
    globals: {
      FinanceContracts: {
        CampaignFinance: './src/contracts/CampaignFinance.move' // Caminho para o contrato de finanças de campanha [[1]](https://poe.com/citation?message_id=260959467175&citation=1)
      },
      syntheticData: {
        use: true,
        path: './synthetic_data/data.json' // Caminho para os dados sintéticos [[6]](https://poe.com/citation?message_id=260959467175&citation=6)
      }
    },
  
    // Define padrões para encontrar os arquivos de teste
    testMatch: ['**/tests/__tests__/**/*.test.move'], // Testes unitários para os contratos Move [[2]](https://poe.com/citation?message_id=260959467175&citation=2)
  };