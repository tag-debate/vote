// Mapeamento das informações dos candidatos
let candidateInfo = {}; // Um mapa para armazenar informações dos candidatos, indexado pelo candidateId

/**
 * Função administrativa para atualizar as informações do candidato.
 * @param {number} adminId - O ID do administrador que está fazendo a atualização.
 * @param {number} candidateId - O ID do candidato cujas informações serão atualizadas.
 * @param {string} newName - O novo nome do candidato.
 * @param {string} newPhotoUrl - A nova URL da foto do candidato.
 */
function updateCandidateInfo(adminId, candidateId, newName, newPhotoUrl) {
    // Verifica se o usuário é um administrador autorizado
    if (!isAdmin(adminId)) {
        throw new Error("Acesso não autorizado.");
    }

    // Atualiza o nome e a foto do candidato
    candidateInfo[candidateId] = {
        name: newName,
        photoUrl: newPhotoUrl,
    };
}

/**
 * Função para verificar se o usuário é um administrador.
 * @param {number} adminId - O ID do administrador.
 * @returns {boolean} - Retorna verdadeiro se o usuário for um administrador.
 */
function isAdmin(adminId) {
    // Lógica para verificar se o usuário é um administrador
    return adminId === 1; // Exemplo simplificado, deve ser ajustado conforme a lógica do sistema
}

module.exports = { updateCandidateInfo };