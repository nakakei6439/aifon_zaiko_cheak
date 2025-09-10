# iPhone 16 Pro Max 512GB - �u���b�N�`�^�j�E���݌Ƀ`�F�b�J�[���s�X�N���v�g

# �G���[���̓���ݒ�
$ErrorActionPreference = "Stop"

# ���O�t�@�C���̃p�X
$logFile = Join-Path $PSScriptRoot "checker_log.txt"

# ���O�֐�
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage
    try {
        Add-Content -Path $logFile -Value $logMessage -ErrorAction SilentlyContinue
    }
    catch {
        # ���O�t�@�C���������݂Ɏ��s�����ꍇ�͖���
    }
}

try {
    Write-Log "=== iPhone 16 Pro Max 512GB - �u���b�N�`�^�j�E���݌Ƀ`�F�b�J�[�J�n ==="

    # ��ƃf�B���N�g�����X�N���v�g�̏ꏊ��
    Set-Location -Path $PSScriptRoot
    Write-Log "��ƃf�B���N�g��: $PWD"

    # Python �̑��݊m�F
    Write-Log "Python�m�F��..."
    try {
        # py �R�}���h�������iWindows Python Launcher�j
        $pythonVersion = & py --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Python�m�F: $pythonVersion (py �R�}���h)"
            $pythonCmd = "py"
        } else {
            # python �R�}���h������
            $pythonVersion = & python --version 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Log "Python�m�F: $pythonVersion (python �R�}���h)"
                $pythonCmd = "python"
            } else {
                throw "Python��������܂���BPython���C���X�g�[�����Ă��������B"
            }
        }
    }
    catch {
        Write-Log "Python�m�F�G���[: $($_.Exception.Message)"
        throw "Python��������܂���BPython���C���X�g�[�����Ă��������B"
    }

    # �ˑ��֌W�̊m�F
    Write-Log "�ˑ��֌W���m�F��..."
    try {
        & $pythonCmd -c "import requests, bs4; print('OK')" 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Log "�K�v�ȃ��C�u�������C���X�g�[����..."
            & $pythonCmd -m pip install -r requirements.txt
            if ($LASTEXITCODE -ne 0) {
                throw "�ˑ��֌W�̃C���X�g�[���Ɏ��s���܂����B"
            }
            Write-Log "�ˑ��֌W�̃C���X�g�[������"
        } else {
            Write-Log "�ˑ��֌W�̊m�F����"
        }
    }
    catch {
        Write-Log "�ˑ��֌W�m�F�G���[: $($_.Exception.Message)"
        throw "�ˑ��֌W�̊m�F�Ɏ��s���܂����B"
    }

    # ���C���X�N���v�g�̎��s
    Write-Log "�݌Ƀ`�F�b�J�[�����s��..."
    try {
        & $pythonCmd "apple_iphone_checker.py"
        if ($LASTEXITCODE -ne 0) {
            throw "�݌Ƀ`�F�b�J�[���s���ɃG���[���������܂����B�I���R�[�h: $LASTEXITCODE"
        }
        Write-Log "�݌Ƀ`�F�b�J�[�̎��s������Ɋ������܂����B"
    }
    catch {
        Write-Log "���C���X�N���v�g���s�G���[: $($_.Exception.Message)"
        throw "�݌Ƀ`�F�b�J�[�̎��s�Ɏ��s���܂����B"
    }
}
catch {
    Write-Log "�G���[���������܂���: $($_.Exception.Message)"
    Write-Log "�G���[�̏ڍ�: $($_.Exception.ToString())"
    exit 1
}
finally {
    Write-Log "=== iPhone 16 Pro Max 512GB - �u���b�N�`�^�j�E���݌Ƀ`�F�b�J�[�I�� ==="
    Write-Log ""
}