#!/bin/bash

# Function to check if Helm is installed
check_helm() {
    if command -v helm &> /dev/null
    then
        echo "Helm is installed."
        helm version --short
        return 0
    else
        echo "Helm is not installed."
        return 1
    fi
}

# Function to install a Helm chart
install_helm_chart() {
    local chart_path="$1"
    local revision_name="$2"

    if [ -z "$chart_path" ]; then
        echo "Error: No Helm chart path provided for installation."
        exit 1
    fi

    if [ ! -d "$chart_path" ]; then
        echo "Error: The specified path does not exist or is not a directory."
        exit 1
    fi

    if [ -z "$revision_name" ]; then
        echo "Error: No revision name provided for installation."
        exit 1
    fi

    echo "Installing Helm chart from: $chart_path with revision name: $revision_name"
    helm install "$revision_name" "$chart_path"
}

# Function to uninstall a Helm chart
uninstall_helm_chart() {
    local revision_name="$1"

    if [ -z "$revision_name" ]; then
        echo "Error: No revision name provided for uninstallation."
        exit 1
    fi

    echo "Uninstalling Helm chart with revision name: $revision_name"
    helm uninstall "$revision_name"
}

# Show usage instructions
show_help() {
    echo "Usage:"
    echo "To install Helm chart run the following command:"
    echo "./run-helm.sh -install -revisionName <name> -path <path-to-helm-chart>"
    echo "To uninstall Helm chart run the following command:"
    echo "./run-helm.sh -uninstall -revisionName <name>"
}

# Parse command-line arguments
install=0
uninstall=0
chart_path=""
revision_name=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -install)
            install=1
            shift
            ;;
        -uninstall)
            uninstall=1
            shift
            ;;
        -path|--path)
            chart_path="$2"
            shift 2
            ;;
        -revisionName)
            revision_name="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

# Main script execution
if check_helm; then
    if [ $install -eq 1 ]; then
        install_helm_chart "$chart_path" "$revision_name"
    elif [ $uninstall -eq 1 ]; then
        uninstall_helm_chart "$revision_name"
    else
        echo "Error: No valid flag provided."
        show_help
        exit 1
    fi
else
    exit 1
fi
